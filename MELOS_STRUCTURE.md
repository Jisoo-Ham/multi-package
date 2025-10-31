
# Melos 프로젝트 구조 설명

이 문서는 현재 프로젝트의 Melos 기반 모노레포 구조에 대해 설명합니다.

## Melos란?

Melos는 Dart 및 Flutter 프로젝트를 위한 모노레포(monorepo) 관리 도구입니다. 모노레포는 여러 개의 관련 프로젝트(패키지)를 단일 코드 저장소에서 관리하는 방식입니다. Melos를 사용하면 다음과 같은 이점을 얻을 수 있습니다.

- **중앙 집중식 관리**: 모든 패키지의 의존성, 스크립트, 버전 관리를 한 곳에서 처리할 수 있습니다.
- **개발 효율성 증대**: 여러 패키지에 걸친 변경 사항을 한 번에 테스트하고 반영하기 용이합니다.
- **일관성 유지**: 모든 패키지에서 동일한 버전의 의존성을 사용하도록 강제하여 일관성을 유지합니다.

## 루트 `pubspec.yaml`의 역할

프로젝트의 루트 디렉토리에 있는 `pubspec.yaml` 파일은 Melos 설정을 중앙에서 관리하는 핵심적인 역할을 합니다.

과거에는 `melos.yaml`이라는 별도의 설정 파일을 사용하는 것이 일반적이었지만, 최신 버전의 Melos(v3)와 Dart Pub은 `pubspec.yaml` 내에서 직접 작업 공간(workspace)을 정의하는 기능을 지원합니다. 이로 인해 별도의 설정 파일 없이 `pubspec.yaml`만으로 Melos를 구성할 수 있습니다.

### `workspace` 속성

```yaml
workspace:
  - app
  - presenter
  - network
  - local_storage
  - usecase
  - entity
```

`workspace` 속성은 Melos가 관리할 패키지들의 목록을 정의합니다. Melos는 이 목록을 보고 어떤 디렉토리들이 모노레포에 포함된 패키지인지 식별합니다.

### `melos` 속성

```yaml
melos:
  scripts:
    # ... 스크립트 정의 ...
```

`melos` 속성 아래에는 이 모노레포에서 사용할 수 있는 공용 스크립트들을 정의합니다. 예를 들어 `melos run build_runner`와 같은 명령어를 실행하면, 여기에 정의된 스크립트가 동작합니다. 이를 통해 모든 패키지에 걸쳐 반복적으로 수행해야 하는 작업(예: 코드 생성, 테스트, 앱 실행)을 자동화할 수 있습니다.

## `resolution: workspace`의 필요성

`resolution: workspace` 설정은 개별 패키지(예: `app`, `presenter` 등)의 `pubspec.yaml` 파일에 추가되어야 하는 중요한 속성입니다.

```yaml
# 예시: app/pubspec.yaml

name: app
description: A new Flutter project.
publish_to: 'none' 
version: 1.0.0+1

environment:
  sdk: '>=3.2.3 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # 워크스페이스 내의 다른 패키지를 참조
  presenter:
    path: ../presenter

# 이 부분이 중요합니다!
resolution: workspace
```

### 왜 필요한가?

1.  **로컬 패키지 참조**: `app` 패키지가 `presenter` 패키지에 의존한다고 가정해 봅시다. `resolution: workspace`가 없다면, `flutter pub get` 명령어는 `presenter` 패키지를 `pub.dev`와 같은 외부 저장소에서 찾으려고 시도합니다.
2.  **의존성 해결**: 이 설정을 사용하면, `pub`은 의존성을 해결할 때 먼저 모노레포 작업 공간(workspace) 내부를 확인합니다. 즉, `pub.dev`에서 패키지를 가져오는 대신, 로컬에 있는 최신 버전의 `presenter` 코드를 직접 참조하게 됩니다.
3.  **단일 버전 원칙**: 작업 공간 내의 모든 패키지들이 특정 외부 패키지(예: `http`)에 의존할 때, Melos는 모든 패키지가 동일한 버전의 `http`를 사용하도록 보장합니다. `resolution: workspace`는 이러한 버전 통일을 가능하게 하는 핵심 요소입니다.

결론적으로, 이 설정은 모노레포 내 패키지 간의 의존성을 외부 원격 저장소가 아닌 로컬에서 직접 해결하도록 `pub`에게 알려주는 역할을 하며, 이는 모노레포 개발의 핵심적인 부분입니다.

## 요약

-   루트 `pubspec.yaml`의 `workspace` 속성을 통해 Melos가 관리할 패키지를 정의합니다.
-   `melos` 속성을 통해 모노레포 전체에서 사용할 스크립트를 정의할 수 있습니다.
-   개별 패키지의 `pubspec.yaml`에 `resolution: workspace`를 추가하여, 패키지 간 의존성을 외부가 아닌 로컬 작업 공간 내에서 해결하도록 해야 합니다.
