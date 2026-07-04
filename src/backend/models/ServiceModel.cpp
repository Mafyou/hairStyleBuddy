#include "ServiceModel.h"

ServiceModel::ServiceModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_data({

        // ── COULEUR ───────────────────────────────────────────────────────────
        { 1, "Couleur", "Blond naturel", "Oxydant 30vol — ratio 1:1.5", 35, {
            "Doser 50g de couleur + 75ml d'oxydant 30vol",
            "Mélanger énergiquement 2 min jusqu'à crème lisse",
            "Appliquer sur cheveux secs, racines en premier",
            "Recouvrir d'un film plastique",
            "Laisser poser 35 min — contrôler à 25 min",
            "Rincer abondamment, shampooer, appliquer soin",
        }},
        { 2, "Couleur", "Blond cendré", "Oxydant 20vol — ratio 1:1.5", 35, {
            "Doser 50g de couleur cendré + 75ml d'oxydant 20vol",
            "Mélanger 2 min jusqu'à consistance lisse",
            "Appliquer sur cheveux propres et secs",
            "Laisser poser 35 min à température ambiante",
            "Surveiller la neutralisation des reflets chauds (orange/jaune)",
            "Rincer à l'eau froide, shampooer",
        }},
        { 3, "Couleur", "Châtain doré", "Oxydant 20vol — ratio 1:1.5", 25, {
            "Doser 50g de couleur + 75ml d'oxydant 20vol",
            "Mélanger et appliquer sur toute la longueur",
            "Insister sur les zones décolorées ou résistantes",
            "Laisser poser 25 min",
            "Contrôler la chaleur du reflet doré avant de rincer",
            "Rincer, shampooer",
        }},
        { 4, "Couleur", "Brun chocolat", "Oxydant 10vol — ratio 1:1.5", 20, {
            "Doser 50g de couleur + 75ml d'oxydant 10vol",
            "Mélanger jusqu'à consistance homogène",
            "Appliquer de la nuque vers le sommet, longueurs puis racines",
            "L'oxydant 10vol ne lève pas — il colore uniquement",
            "Laisser poser 20 min",
            "Rincer abondamment, shampooer",
        }},
        { 5, "Couleur", "Décoloration", "Poudre déco + Oxydant 40vol", 50, {
            "Doser poudre + oxydant 40vol selon instructions fabricant",
            "Mélanger jusqu'à pâte homogène — utiliser immédiatement",
            "Appliquer mèche par mèche en commençant par les zones les plus résistantes",
            "Ne jamais poser sur le cuir chevelu",
            "Contrôler la levée toutes les 10 min — max 50 min",
            "Rincer abondamment, shampooer, appliquer masque réparateur (NOUNOU)",
        }},
        { 6, "Couleur", "Mèches", "Oxydant 30vol — papier alu", 50, {
            "Mélanger poudre déco + oxydant 30vol",
            "Prendre des mèches de 0.5 à 1 cm, poser sur feuille de papier alu",
            "Appliquer la préparation du milieu de mèche vers les pointes",
            "Replier l'alu et procéder mèche par mèche sur toute la tête",
            "Laisser poser 35 à 50 min selon résistance — contrôler régulièrement",
            "Rincer, shampooer, appliquer soin ou toning pour harmoniser",
        }},
        { 7, "Couleur", "Toning", "Sans oxydant — ratio toner 1:2 eau", 10, {
            "Vérifier que les cheveux sont bien décolorés et propres",
            "Doser 1 part de toner pour 2 parts d'eau tiède",
            "Mélanger à température ambiante",
            "Appliquer sur cheveux humides de façon uniforme",
            "Laisser poser 10 min en vérifiant régulièrement",
            "Rincer à l'eau claire — ne pas shampooer pour fixer le pigment",
        }},

        // ── SOIN Davines ──────────────────────────────────────────────────────
        { 8, "Soin", "OI", "Nutrition absolue — tous types de cheveux", 15, {
            "Shampooer avec OI Shampoo (1 à 2 passages)",
            "Essorer les cheveux sans frotter avec une serviette",
            "Appliquer OI Mask sur longueurs et pointes",
            "Laisser poser 15 min (chaleur douce possible pour booster)",
            "Rincer abondamment à l'eau tiède",
            "Appliquer quelques gouttes d'OI Oil sur cheveux humides avant séchage",
        }},
        { 9, "Soin", "MOMO", "Hydratation — cheveux secs ou déshydratés", 20, {
            "Shampooer avec MOMO Shampoo",
            "Essorer sans frotter",
            "Appliquer MOMO Mask généreusement sur longueurs et pointes",
            "Envelopper d'une serviette chaude pour intensifier le soin",
            "Laisser poser 20 min",
            "Rincer à l'eau tiède — finir avec MOMO Serum sur les pointes si besoin",
        }},
        { 10, "Soin", "NOUNOU", "Nutrition intense — cheveux chimiquement traités", 20, {
            "Shampooer avec NOUNOU Shampoo",
            "Appliquer NOUNOU Mask en couche épaisse sur longueurs",
            "Masser pour faire pénétrer, couvrir d'un film plastique",
            "Chauffer 5 min avec casque chauffant pour ouvrir les écailles",
            "Laisser poser encore 15 min",
            "Rincer abondamment à l'eau tiède",
        }},
        { 11, "Soin", "LOVE", "Lissage anti-frizz — cheveux indisciplinés", 20, {
            "Shampooer avec LOVE Shampoo",
            "Appliquer LOVE Mask sur longueurs uniquement (éviter les racines)",
            "Peigner pour répartir le produit uniformément",
            "Laisser poser 20 min",
            "Rincer abondamment",
            "Sécher en lissant les cheveux vers le bas avec une brosse plate",
        }},
        { 12, "Soin", "SU", "Protection solaire — avant exposition UV", 10, {
            "Shampooer avec SU Shampoo",
            "Appliquer SU Mask sur cheveux humides",
            "Laisser poser 10 min",
            "Rincer à l'eau tiède",
            "Appliquer SU Hair Oil sur cheveux humides avant séchage",
            "Ne pas rincer l'huile — elle protège des UV tout au long de la journée",
        }},
        { 13, "Soin", "SOLU", "Purification — cuir chevelu gras", 15, {
            "Appliquer SOLU Scrub sur cuir chevelu humide",
            "Masser en mouvements circulaires pendant 2 à 3 min",
            "Rincer abondamment à l'eau tiède",
            "Shampooer avec SOLU Shampoo",
            "Appliquer SOLU Conditioner sur longueurs uniquement",
            "Rincer et sécher normalement",
        }},
        { 14, "Soin", "Ritual complet", "OI + NOUNOU — soin en profondeur", 45, {
            "Shampooer 2 fois avec OI Shampoo",
            "Essorer et appliquer OI Mask en couche généreuse sur toute la longueur",
            "Couvrir d'un film plastique et chauffer 5 min au casque",
            "Laisser poser encore 15 min — rincer",
            "Ré-appliquer NOUNOU Mask sur les pointes uniquement",
            "Laisser poser 5 min puis rincer",
            "Finir avec quelques gouttes d'OI Oil sur cheveux humides avant séchage",
        }},

        // ── COUPE ─────────────────────────────────────────────────────────────
        { 15, "Coupe", "Coupe femme", "Ciseaux + effilage — formes et longueurs", 0, {
            "Shampooer et démêler soigneusement",
            "Diviser les cheveux en 4 sections : 2 avant, 2 arrière",
            "Commencer par la nuque, couper la longueur guide bien horizontale",
            "Remonter section par section en suivant la ligne de base",
            "Effiler et désépaissir selon la densité des cheveux",
            "Vérifier la symétrie des deux côtés avant de terminer",
        }},
        { 16, "Coupe", "Coupe + brushing", "Ciseaux + soufflage brosse ronde", 0, {
            "Shampooer et appliquer soin démêlant",
            "Diviser en sections régulières de 2 à 3 cm",
            "Couper la longueur souhaitée section par section",
            "Sécher en soulevant la racine avec la brosse ronde (volume)",
            "Lisser les pointes vers l'intérieur ou l'extérieur selon coiffure",
            "Terminer avec un sérum léger pour le brillant",
        }},
        { 17, "Coupe", "Coupe + lissage", "Ciseaux + lisseur ou boucleur", 0, {
            "Shampooer, appliquer protection thermique sur toute la longueur",
            "Diviser en sections de 2 cm",
            "Couper la longueur et les dégradés voulus",
            "Sécher à 80% à la main en lissant vers le bas",
            "Passer le lisseur à 200°C section par section (ou boucleur pour boucles)",
            "Finir avec une huile légère pour le brillant et l'effet",
        }},
        { 18, "Coupe", "Coupe homme classique", "Ciseaux + tondeuse sur les côtés", 0, {
            "Humidifier les cheveux au spray",
            "Peigner pour dégager les lignes naturelles de la tête",
            "Passer la tondeuse N°3 ou N°4 sur les côtés et la nuque",
            "Couper le dessus aux ciseaux en suivant la forme de la tête",
            "Dégager soigneusement les contours des oreilles et de la nuque",
            "Finir le contour au rasoir ou à la tondeuse N°0 pour la netteté",
        }},
        { 19, "Coupe", "Dégradé fondu", "Tondeuse progressif — plusieurs hauteurs", 0, {
            "Tondeuse N°1 à la base, juste au-dessus des oreilles",
            "Monter progressivement : N°2 à mi-hauteur des côtés",
            "N°3 puis N°4 vers le sommet pour un fondu naturel",
            "Fondre chaque transition avec le levier ouvert/fermé en remontant",
            "Finir le dessus aux ciseaux pour garder de la longueur",
            "Vérifier la régularité de chaque côté face au miroir",
        }},
        { 20, "Coupe", "Coupe enfant", "Fille ou garçon — 12 ans et -", 0, {
            "Asseoir confortablement, cape bien installée",
            "Humidifier les cheveux au spray",
            "Commencer par la nuque, couper bien horizontal",
            "Couper droit pour les coupes simples, en V pour les longueurs",
            "Effiler légèrement pour alléger si cheveux épais",
            "Sécher rapidement et avec douceur",
        }},

        // ── BALAYAGE ──────────────────────────────────────────────────────────
        { 21, "Balayage", "Balayage classique", "Mèches larges à la main — effet naturel", 45, {
            "Diviser les cheveux en sections horizontales de 3 à 4 cm",
            "Poser chaque section sur une feuille de papier alu",
            "Appliquer le produit décolorant à 2-3 cm des racines",
            "Ne pas aller jusqu'aux pointes (garder 1-2 cm naturels)",
            "Replier l'alu et procéder sur toute la tête",
            "Laisser poser 35 à 45 min — contrôler la levée régulièrement",
            "Rincer, shampooer, appliquer toning si besoin",
        }},
        { 22, "Balayage", "Balayage soleil", "Dégradé doré, tons chauds et lumineux", 35, {
            "Séparer 3 à 4 sections dans la partie haute de la tête",
            "Appliquer le décolorant à main levée sur les longueurs",
            "Concentrer sur les zones exposées au soleil : dessus et devant",
            "Technique balayage : partir du milieu de la mèche vers les pointes",
            "Laisser les racines complètement naturelles",
            "Poser 35 min, rincer, appliquer toning doré chaud pour harmoniser",
        }},
        { 23, "Balayage", "Baby lights", "Très fines mèches papier alu — ultra naturel", 45, {
            "Prendre des mèches très fines (2 à 3 mm) avec un peigne à dents fines",
            "Poser chaque mèche sur une feuille de papier alu fin",
            "Appliquer le décolorant légèrement — le résultat doit rester très discret",
            "Procéder sur toute la tête, section par section",
            "Laisser poser 40 à 45 min selon niveau de départ et résistance",
            "Rincer, shampooer, appliquer toning nacré ou naturel",
        }},
        { 24, "Balayage", "Ombré hair", "Racines sombres → dégradé vers pointes claires", 40, {
            "Définir la zone de transition (généralement milieu de longueur)",
            "Faire un dégradé flou à la limite racines / longueurs avec une brosse",
            "Décolorer de la zone de transition vers les pointes",
            "Fondre la démarcation avec un peigne ou les doigts pour éviter une ligne dure",
            "Laisser poser 40 min en contrôlant régulièrement la levée",
            "Rincer, shampooer, appliquer toning selon la teinte voulue",
        }},
        { 25, "Balayage", "Balayage + tono", "Balayage + toning assorti pour harmoniser", 50, {
            "Réaliser le balayage classique (voir fiche Balayage classique)",
            "Rincer et shampooer après la levée complète",
            "Choisir le toning assorti : tons froids pour cendré, chauds pour doré",
            "Doser le toner 1:2 avec de l'eau tiède",
            "Appliquer sur longueurs et pointes humides de façon uniforme",
            "Laisser poser 10 min, contrôler la teinte, rincer à l'eau claire",
        }},
    })
{}

int ServiceModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_data.size();
}

QVariant ServiceModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.size())
        return {};

    const Service &s = m_data.at(index.row());
    switch (role) {
    case IdRole:         return s.id;
    case CategoryRole:   return s.category;
    case NameRole:       return s.name;
    case SubtitleRole:   return s.subtitle;
    case ProcessingRole: return s.processingMinutes;
    case StepsRole:      return s.steps;
    default:             return {};
    }
}

QHash<int, QByteArray> ServiceModel::roleNames() const
{
    return {
        { IdRole,         "serviceId"  },
        { CategoryRole,   "category"   },
        { NameRole,       "name"       },
        { SubtitleRole,   "subtitle"   },
        { ProcessingRole, "processing" },
        { StepsRole,      "steps"      },
    };
}
