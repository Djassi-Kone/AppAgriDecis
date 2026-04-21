from datetime import datetime, timedelta
from django.utils import timezone
from contents.models import Content
from users.models import User

# Récupérer l'agronome
agronome = User.objects.filter(role='agronome').first()
if not agronome:
    print("Aucun agronome trouvé. Créez d'abord un compte agronome.")
    exit()

# Contenus dynamiques basés sur la saison et les réalités agricoles
contenus_data = [
    {
        'title': 'Conseils pour la culture de riz en saison des pluies',
        'description': 'Guide complet pour optimiser votre production de riz pendant la saison des pluies',
        'content_type': 'article',
        'category': 'céréales',
        'tags': ['riz', 'saison des pluies', 'irrigation', 'fertilisation'],
        'content': '''
# Culture du Riz en Saison des Pluies

## Préparation du Champ
- Assurez-vous que le champ est bien nivelé
- Mettez en place un bon système de drainage
- Préparez les pépinières 3 semaines avant la transplantation

## Variétés Recommandées
Pour la saison des pluies, privilégiez les variétés:
- Résistantes aux maladies fongiques
- Cycle court (90-110 jours)
- Tolérantes à l'humidité

## Gestion de l'Eau
- Maintenez 2-3 cm d'eau pendant les 3 premières semaines
- Augmentez progressivement jusqu'à 5-10 cm
- Drainez 2 semaines avant la récolte

## Fertilisation
- Base: 40kg P2O5/ha au repiquage
- Couverture: 30kg N/ha 3 semaines après repiquage
- Deuxième couverture: 30kg N/ha à initiation paniculaire

## Protection Phytosanitaire
Surveillez particulièrement:
- Pyriculariose du riz
- Chenilles défoliatrices
- Taches brunes

Contactez-moi pour des conseils personnalisés selon votre parcelle.
        '''
    },
    {
        'title': 'Lutte biologique contre les ravageurs du maïs',
        'description': 'Méthodes écologiques pour protéger vos cultures de maïs',
        'content_type': 'guide',
        'category': 'légumes',
        'tags': ['maïs', 'lutte biologique', 'ravageurs', 'pesticides naturels'],
        'content': '''
# Lutte Biologique contre les Ravageurs du Maïs

## Ravageurs Principaux
1. **Foreur de la tige**: Sesamia nonagrioides
2. **Pyrale du maïs**: Ostrinia nubilalis
3. **Puceron du maïs**: Rhopalosiphum maidis

## Méthodes de Prévention

### Rotation des Cultures
- Évitez les monocultures de maïs
- Alternez avec des légumineuses (haricots, niébé)

### Variétés Résistantes
- Choisissez des variétés locales adaptées
- Privilégiez les hybrides résistants aux maladies

### Lutte Mécanique
- Destruction des résidus de récolte
- Labour profond en saison sèche
- Arrachage manuel des plants infestés

### Auxiliaires de Culture
- Plantez des fleurs (souci, tagètes) pour attirer les prédateurs
- Installez des nichoirs pour oiseaux insectivores
- Préservez les araignées et coccinelles

### Traitements Naturels
- **Extrait de neem**: 30ml/litre, pulvérisation hebdomadaire
- **Feuilles de papaye**: 1kg/10l, fermentation 48h
- **Cendres de bois**: 200g/m² au pied des plants

## Surveillance
- Inspectez les plants 2 fois par semaine
- Notez les premiers symptômes
- Agissez rapidement dès détection

## Seuil d'Intervention
Intervenez si:
- 10% de plants touchés par les foreurs
- Plus de 20 pucerons par plante
- Présence de masses d'oeufs

Pour une assistance personnalisée, partagez des photos de vos cultures.
        '''
    },
    {
        'title': 'Techniques de conservation des récoltes',
        'description': 'Méthodes traditionnelles et modernes pour stocker vos productions',
        'content_type': 'tutorial',
        'category': 'stockage',
        'tags': ['conservation', 'stockage', 'récoltes', 'post-récolte'],
        'content': '''
# Conservation des Récoltes

## Séchage
- Humidité cible: 12-14% pour les céréales
- Étalez sur bâches propres
- Retournez 2-3 fois par jour
- Durée: 3-7 jours selon le soleil

## Stockage des Céréales
### Méthodes Traditionnelles
- **Greniers en banco**: 20cm d'épaisseur, toit en chaume
- **Jarres en terre cuite**: hermétiques, ajout de cendre
- **Sacs en jute**: avec produits naturels (feuilles de neem)

### Méthodes Modernes
- **Silos métalliques**: hermétiques avec traitement CO2
- **Sacs hermétiques**: PICS bags, Triple layer bags
- **Conteneurs réfrigérés**: pour produits à haute valeur

## Conservation des Légumes
### Racines (igname, manioc)
- Caves ou fosses sombres
- Température: 15-20°C
- Humidité: 70-80%
- Durée: 3-6 mois

### Fruits et Légumes Feuilles
- Réfrigération si disponible
- Emballage perforé
- Durée: 1-2 semaines

## Traitement Post-Récolte
### Nettoyage
- Éliminez les débris végétaux
- Triez les produits endommagés
- Lavez si nécessaire

### Traitement
- **Thermal**: 60°C pendant 30min (insectes)
- **Fumigation**: naturelle avec plantes locales
- **Enrobage**: argile + cendre

## Contrôle Qualité
- Inspection hebdomadaire
- Test d'humidité
- Détection précoce des moisissures

## Perte Post-Récolte
Objectifs:
- Céréales: <10%
- Racines: <20%
- Légumes: <30%

Contactez-moi pour des solutions adaptées à votre production.
        '''
    },
    {
        'title': 'Alerte météo: préparation pour la saison sèche',
        'description': 'Comment anticiper et gérer les défis de la saison sèche',
        'content_type': 'alert',
        'category': 'météo',
        'tags': ['saison sèche', 'sécheresse', 'irrigation', 'prévention'],
        'content': '''
# Alerte Saison Sèche - Préparation Essentielle

## Période Concernée
**Novembre à Mars** - Période de sécheresse attendue

## Risques Anticipés
- **Sécheresse modérée à sévère**: 60-80% de réduction des précipitations
- **Vents chauds et desséchants**: Risque d'évaporation élevé
- **Températures élevées**: 35-42°C pendant la journée

## Actions Immédiates

### 1. Gestion de l'Eau
- **Stockage maximal**: Remplissez réservoirs et bassines
- **Récupération eau pluie**: Installez des gouttières si possible
- **Irrigation au goutte-à-goutte**: Réduction 50% consommation

### 2. Protection des Sols
- **Paillage**: Couvrez le sol avec paille, feuilles mortes
- **Mulching plastique**: Pour cultures maraîchères
- **Tranchées de conservation**: 15-20cm de profondeur

### 3. Choix des Variétés
- **Résistantes à la sécheresse**: Mil, sorgho, niébé
- **Cycle court**: Récolte avant pic sécheresse
- **Systèmes racinaires profonds**: Betterave, patate douce

### 4. Planification des Cultures
- **Calendrier adapté**: Semis précoce (septembre-octobre)
- **Associations de cultures**: Légumineuses + céréales
- **Cultures de couverture**: Pour protéger le sol

## Mesures d'Urgence

### Signal d'Alerte
- **Fleurissement précoce**: Signe de stress hydrique
- **Jaunissement des feuilles**: Déficit en eau
- **Fissuration du sol**: Sécheresse avancée

### Interventions
- **Arrosage ciblé**: 2-3L par plante/jour
- **Ombre artificielle**: Filet ombrage 50%
- **Anti-transpirants**: Applications foliaires

## Assistance Technique
Pour un plan personnalisé:
- Analysons votre parcelle ensemble
- Évaluons vos ressources en eau
- Déterminons les cultures les plus adaptées

**Contactez-moi rapidement pour une consultation gratuite!**
        '''
    }
]

# Créer les contenus
for contenu_data in contenus_data:
    # Vérifier si le contenu existe déjà
    if Content.objects.filter(title=contenu_data['title'], author=agronome).exists():
        print(f"Le contenu '{contenu_data['title']}' existe déjà")
        continue
    
    # Créer le contenu
    contenu = Content.objects.create(
        title=contenu_data['title'],
        description=contenu_data['content'],  # Utiliser description pour le contenu principal
        content_type=contenu_data['content_type'],
        category=contenu_data['category'],
        tags=','.join(contenu_data['tags']),  # Convertir liste en string
        author=agronome,
        status='published',
        published_at=timezone.now()
    )
    
    print(f"Contenu créé: {contenu.title}")

print("\n=== Contenus créés avec succès ===")
print(f"Total: {len(contenus_data)} contenus publiés")
print(f"Auteur: {agronome.email}")
print("\nLes agriculteurs peuvent maintenant:")
print("- Voir ces contenus")
print("- Liker et commenter")
print("- Poser des questions dans le chat IA")
