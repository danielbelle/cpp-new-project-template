#!/bin/bash
# Script de configuração automática para template Git
# Este script roda automaticamente após o clone

echo ""
echo "=== 🚀 CONFIGURANDO TEMPLATE AUTOMATICAMENTE ==="
echo ""

# Obter nome da pasta atual (projeto)
PROJECT_NAME=$(basename "$PWD")
echo "📁 Nome da pasta detectado: $PROJECT_NAME"

# Função para sanitizar nome
sanitize_name() {
    echo "$1" | sed -E 's/[[:space:]_]+/-/g' | sed -E 's/[^a-zA-Z0-9-]//g' | tr '[:upper:]' '[:lower:]' | sed -E 's/--+/-/g' | sed -E 's/^-//' | sed -E 's/-$//'
}

SANITIZED_NAME=$(sanitize_name "$PROJECT_NAME")

if [ "$SANITIZED_NAME" != "$PROJECT_NAME" ]; then
    echo "🔧 Nome sanitizado: $SANITIZED_NAME"
fi

echo "🔄 Atualizando arquivos de configuração..."

# Atualizar CMakeLists.txt
if [ -f "CMakeLists.txt" ]; then
    sed -i.tmp -E "s/(set\\(PROJECT_NAME \")[^\"]+(\"\\))/set(PROJECT_NAME \"${SANITIZED_NAME}\")/" CMakeLists.txt
    sed -i.tmp -E "s/(project\\()[^)]+(\\))/project(${SANITIZED_NAME})/" CMakeLists.txt
    sed -i.tmp -E "s/(add_executable\\()[^ ]+/add_executable(${SANITIZED_NAME}/" CMakeLists.txt
    rm -f CMakeLists.txt.tmp 2>/dev/null
    echo "✅ CMakeLists.txt configurado"
fi

# Atualizar e renomear script run
if [ -f "run" ]; then
    # Atualizar variável no arquivo
    sed -i.tmp -E "s/(PROJECT_NAME=\")[^\"]+(\")/PROJECT_NAME=\"${SANITIZED_NAME}\"/" run
    rm -f run.tmp 2>/dev/null
    
    # Renomear arquivo
    mv "run" "${SANITIZED_NAME}"
    chmod +x "${SANITIZED_NAME}"
    echo "✅ Script de build renomeado para: ${SANITIZED_NAME}"
fi

# Criar arquivo de identificação
echo "PROJECT_NAME=${SANITIZED_NAME}" > ".project_config"
echo "CONFIGURED_AUTO=true" >> ".project_config"
echo "ORIGINAL_TEMPLATE=template-build" >> ".project_config"
echo "CONFIGURED_AT=$(date)" >> ".project_config"

# Remover hooks para não interferir no novo projeto
if [ -d ".git/hooks" ]; then
    rm -f .git/hooks/post-checkout
    echo "✅ Hooks de template removidos"
fi

# Remover este script após execução
rm -f "$0"

echo ""
echo "🎉 CONFIGURAÇÃO AUTOMÁTICA CONCLUÍDA!"
echo "📋 Próximos passos:"
echo "   Execute './${SANITIZED_NAME}' para compilar e rodar o projeto"
echo "   Ou use: 'cmake -B build && cmake --build build'"
echo ""