#include "../includes/main.hpp"

int main() {
  // Configurar UTF-8 no console
  configurarUTF8();

  // Seu código aqui
  processInput();

  return 0;
}

void processInput() {
  // Lógica para processar a entrada do usuário
  int opcao;
  do {
    cout << "\n=== 🏠 BEM VINDO(A)! ===" << endl;
    cout << "Este é um template c++ estruturado e modular." << endl;
    cout << "0. Sair\nEscolha: ";
    cin >> opcao;
    cout << "Você digitou: " << opcao << endl;
    /* code */
  } while (opcao != 0);

  return;
}