from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .chat_serializers import ChatRequestSerializer, ChatSessionSerializer
from .models import ChatMessage, ChatSession, DiagnosisRequest
from .serializers import DiagnosisRequestSerializer
from .services import generate_advice_reply, run_diagnosis


class DiagnosisView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        serializer = DiagnosisRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        dr = DiagnosisRequest.objects.create(
            user=request.user,
            image=serializer.validated_data["image"],
            culture=serializer.validated_data.get("culture", ""),
            status="pending",
        )

        try:
            result = run_diagnosis(dr.image.path)
            dr.result_json = result
            dr.status = "done"
            dr.save(update_fields=["result_json", "status"])
        except Exception as e:  # noqa: BLE001
            dr.status = "error"
            dr.error_message = str(e)
            dr.save(update_fields=["status", "error_message"])

        return Response(DiagnosisRequestSerializer(dr).data)


class DiagnosisHistoryView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = DiagnosisRequest.objects.filter(user=request.user).order_by("-created_at")
        return Response(DiagnosisRequestSerializer(qs, many=True).data)


class ChatView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        req_ser = ChatRequestSerializer(data=request.data)
        req_ser.is_valid(raise_exception=True)
        session_id = req_ser.validated_data.get("session_id")
        message = req_ser.validated_data.get("message", "") or ""
        attachment = req_ser.validated_data.get("attachment")

        if session_id:
            session = ChatSession.objects.get(id=session_id, user=request.user)
        else:
            session = ChatSession.objects.create(user=request.user)

        ChatMessage.objects.create(session=session, role=ChatMessage.Role.USER, content=message, attachment=attachment)

        llm_resp = generate_advice_reply(message)
        assistant_content = llm_resp.get("content", "")
        ChatMessage.objects.create(session=session, role=ChatMessage.Role.ASSISTANT, content=assistant_content)

        return Response(
            {
                "session": ChatSessionSerializer(session).data,
                "reply": assistant_content,
                "provider": llm_resp.get("provider"),
                "model": llm_resp.get("model"),
                "messages": [
                    {
                        "role": m.role,
                        "content": m.content,
                        "attachment": m.attachment.url if m.attachment else None,
                        "created_at": m.created_at,
                    }
                    for m in session.messages.order_by("created_at")
                ],
            }
        )


class ChatHistoryView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        session_id = request.query_params.get("session_id")
        if not session_id:
            return Response({"detail": "session_id requis"}, status=400)
        try:
            session = ChatSession.objects.get(id=session_id, user=request.user)
        except ChatSession.DoesNotExist:
            return Response({"detail": "Session introuvable"}, status=404)

        return Response(
            {
                "session": ChatSessionSerializer(session).data,
                "messages": [
                    {
                        "role": m.role,
                        "content": m.content,
                        "attachment": m.attachment.url if m.attachment else None,
                        "created_at": m.created_at,
                    }
                    for m in session.messages.order_by("created_at")
                ],
            }
        )
