# Contexte projet — hairStyleBuddy

Application staff pour un salon de coiffure. Interface tactile plein écran, légère, destinée au personnel (pas aux clients).

## Cible matérielle

- **Exécution** : Raspberry Pi Zero 2 W — CPU Cortex-A53 1 GHz, 512 MB RAM, OpenGL ES 2.0
- **Build / tests** : Raspberry Pi 5 @ `192.168.1.231`
- **Déploiement** : Pi Zero 2 W @ `192.168.1.247`
- **Écran** : tactile résistif, résolution ~800×480, plein écran sans gestionnaire de fenêtres

## Stack technique

- **Qt 6.5+** — QML / Qt Quick Controls 2 (style Basic), backend C++17
- **UI** : `ApplicationWindow` → `StackView` → pages QML
- **Backend** : C++ pur — modèles, services, logique métier
- **Données** : SQLite local via `QSqlDatabase` (driver QSQLITE)
- **Config** : JSON local via `QJsonDocument` / `SettingsService`

## Règle d'or architecture

> **QML = UI et interactions. C++ = tout le reste.**

Pas de logique métier en JavaScript QML. Les modèles C++ (`QAbstractListModel`) sont exposés à QML via des propriétés de `AppController`, lui-même enregistré comme `appController` dans le contexte QML.

## Structure du projet

```
src/
  main.cpp
  backend/
    AppController.h / .cpp          ← point d'entrée exposé à QML
    models/
      AppointmentModel.h / .cpp     ← QAbstractListModel, rôles : appointmentId, clientName, apptTime, service, arrived
      ServiceModel.h / .cpp         ← QAbstractListModel, rôles : serviceId, name, duration, price
    services/
      LocalDbService.h / .cpp       ← SQLite : tables appointments, services, quick_notes
      SettingsService.h / .cpp      ← config JSON (salonName, etc.)
qml/
  Main.qml                          ← ApplicationWindow + StackView + câblage navigation
  HomePage.qml                      ← grille 2×2 de tuiles tactiles
  AppointmentsPage.qml              ← liste RDV du jour + bouton Arrivée
  ServicesPage.qml                  ← liste prestations / durée / prix
  ActionTile.qml                    ← composant tuile réutilisable (Rectangle + TapHandler)
  PageHeader.qml                    ← en-tête avec bouton Retour
scripts/
  deploy.sh                         ← rsync → Pi 5, cmake build, scp → Pi Zero 2 W
  install-autostart.sh              ← installe le service systemd sur Pi Zero 2 W
```

## Contraintes UI strictes

- Plein écran, pas de barre de titre OS
- Gros éléments tactiles (hauteur min 60 px, touch target min 48 px)
- **Pas d'animations** (trop lourd pour Pi Zero 2 W) — pas de `Behavior`, pas de `Transition`, pas d'`Animator`
- Pas de `WebEngineView`, pas de vidéo, pas d'effets de shader
- Pas de logique JS complexe dans QML
- Style Qt Quick Controls : `Basic` (forcé via `qputenv` dans `main.cpp`)
- Maximum 4 à 6 écrans réels

## Palette de couleurs

| Usage            | Couleur   |
|------------------|-----------|
| Fond de page     | `#F5F3F0` |
| En-tête          | `#2C2C2C` |
| Texte principal  | `#1C1C1E` |
| Texte secondaire | `#8E8E93` |
| Accent (prix)    | `#C4956A` |
| Arrivée confirmée| `#34C759` |
| Tuile RDV        | `#EAE0D5` |
| Tuile Prestations| `#D5E8D8` |
| Tuile Notes      | `#D5DDE8` |
| Tuile QR         | `#E8D5E2` |

## Navigation

`StackView` centralisé dans `Main.qml`. Les pages émettent des **signaux de navigation** (`signal goToAppointments()`), `Main.qml` les câble aux `Component` correspondants. Le retour arrière se fait via `page.StackView.view.pop()` dans chaque page (`page` étant l'id de l'élément racine directement dans le StackView).

## Base de données SQLite

Tables :
- `appointments` — `id, client_name, time, service, date, arrived`
- `services` — `id, name, duration_minutes, price`
- `quick_notes` — `id, content, created_at`

Les RDV sont filtrés par `date = date('now')` (format ISO `YYYY-MM-DD`). Des données de démo sont seedées au premier lancement.

## Profil développeur

Développeur principal orienté .NET / C#. Faire des analogies avec l'écosystème .NET quand c'est utile :
- `QAbstractListModel` ≈ `ObservableCollection` / `INotifyCollectionChanged`
- Signaux/slots Qt ≈ événements C# / delegates
- `QML` ≈ XAML (binding déclaratif, séparation UI/logique)
- `CMakeLists.txt` ≈ `.csproj`
- `qputenv` ≈ variables d'environnement en `launchSettings.json`
