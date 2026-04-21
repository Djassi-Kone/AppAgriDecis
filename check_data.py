from contents.models import Content
from users.models import User

print('=== Vérification des contenus ===')
print(f'Contents count: {Content.objects.count()}')

for c in Content.objects.all():
    print(f'- {c.title} by {c.author.email} ({c.status})')

print('\n=== Vérification des utilisateurs ===')
for u in User.objects.all():
    print(f'- {u.email} ({u.role}) - Active: {u.is_active}')
