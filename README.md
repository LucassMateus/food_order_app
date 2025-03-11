# FoodOrderApp

FoodOrderApp é um aplicativo de self-service para bares/restaurantes. Ele permite ao cliente:

- Escolher seus lanches
- Inserir cupom de desconto
- Escolher local de entrega
- Escolher a forma de pagamento. 

Os dados do aplicativo são fixos, pois o projeto é um protótipo, onde o foco principal foi a implementação da arquitetura recomendada pela documentação oficial do Flutter.

---

## 💻 **Tecnologias utilizadas**

**Provider:**  
Injeção de dependências.

**ChangeNotifier:**  
Gerenciamento de estado.

**Result:**   
Tratamento de erros.

---

## 🛠️ **Arquitetura e design patterns**

### **Arquitetura**
---
- **ARQUITETURA EM CAMADAS:** 
    ![ARQUITETURA EM CAMADAS](https://docs.flutter.dev/assets/images/docs/app-architecture/common-architecture-concepts/horizontal-layers-with-icons.png)
    O app foi divido em camadas distintas, cada uma com funções e responsabilidades específicas:

    - **UI layer:** Exibe dados ao usuário que são expostos pela camada de lógica de negócios e manipula a interação do usuário.

    - **Logic layer:** Implementa a lógica de negócios e facilita a interação entre a camada de dados e a camada de UI. Nos casos de lógica mais complexa ou necessidade de varias fontes de dados foi adicionado UseCases nessa camada.

    - **Data layer:** Gerencia interações com fontes de dados, como bancos de dados ou plugins de plataforma. Expõe dados e métodos à camada de lógica de negócios.


- Para mais informações sobre essa arquitetura: [Common architecture concepts](https://docs.flutter.dev/app-architecture/concepts)

    **Forma de uso no app**
    ![ARQUITETURA EM CAMADAS: Exemplo de uso](https://docs.flutter.dev/assets/images/docs/app-architecture/guide/feature-architecture-simplified-with-logic-layer.png)


### **Padrões**
---
- **MVVM (Model-View-ViewModel):** Utilizamos o padrão MVVM combinado com o Repository Pattern para separar responsabilidades e manter o código escalável e testável.
  - **Model:** Representa os dados e a lógica do negócio.

  - **ViewModel:** Contém toda a lógica e manipulação de dados para a UI.

  - **View:** Exibe os dados ao usuário e delega as interações para o ViewModel.

  - **Repository:** Responsável por gerenciar a comunicação entre a camada de dados e ViewModel. Também denominada como SSOT(single source of truth) da aplicação.

- **STATE PATTERN:**  Esse padrão foi utilizado para gerenciar o estado da aplicação, garantindo que a UI seja atualizada automaticamente conforme as mudanças de estado, onde cada estado representa um momento específico da aplicação.

- **RESULT PATTERN:** Esse padrão foi utilizado para padronizar o tratamento de erros na aplicação, garantindo que os métodos retornem um estado claro sobre sua execução(Success ou Failure).

- **COMMAND PATTERN:** Esse padrão foi utilizado para executar ações dentro do app de forma encapsulada e controlada, garantindo um tratamento de erro mais robusto e uma UI mais reativa.

---

## ⚙️ **Configuração e Execução**

### 1. **Pré-requisitos**
- Flutter SDK (versão mais recente recomendada)
- Ambiente configurado para desenvolvimento Flutter (Android Studio, VSCode, etc.)

### 2. **Instale as Dependências**
Execute o seguinte comando no terminal para instalar todas as dependências:

```bash
flutter pub get
```
### 3. **Conecte um emulador ou dispositivo físico e use o comando:**
```bash
flutter run
```