# Space Invaders

Recriação do jogo Space Invaders para segunda fase do PSel (Processo Seletivo)
do FoG (Fellowship of the Game)

# Metas Obrigatórias
- [X] É um jogo digital
- [X] O jogo abre
- [X] O jogador se pode movimentar a nave horizontalmente
- [X] O jogador pode atirar um laser em linha reta para cima da tela
- [X] Os alienígenas devem aparecer da parte superior da tela
    - [X] Os alienígenas se movem horizontalmente,
    - [X] Quando a linha de de alienígenas atingir o limite da tela,
          deve descer um pouco e andar na outra direção (horizontalmente)
- [X] Se um laser atingir um alienígena, ele deve ser destruído
- [X] Se o jogador for atingido por um laser de um alienígena,
    ele deve perder uma vida
- [X] O jogo acaba quando:
    - [X] O jogador perde todas as suas vidas
    - [X] Um alienígena atinge a parte inferior da tela

# Metas Adicionais
- [ ] Fazer menu iniciar
- [X] Poder pausar o jogo
- [X] Implementar sistema de pontuação
    - [X] Quando o jogador destruir um alienigena
    - [X] Alienígenas mais distante da margem inferior concedem mais pontos
- [X] Implementar mais de uma fase
    - [X] Dificuldade das fases aumentar progressivamente
    - [X] Ter mais de um tipo de alienígena
- [X] Inserir alienígena de bonûs que passa rapidamente no topo da tela,
      de tempos em tempos
- [ ] Estruturas que protege o jogador


# Outras Funcionalidades
- [X] O Highscore é salvo em uma arquivo
- [X] Criar menu de pausa
- [X] Janela pode ser redimensionada
    - [X] É possível usar tela cheia
- [X] Efeito de explosão para o alienígena

# Controles
O jogo é controlado através do teclado,
sendo as teclas e as ações as seguintes:

| Tecla              | Ação                |
|:------------------:|---------------------|
| Esc                | Pusa                |
| Seta para esquerda | Mover para esquerda |
| A                  | Mover para esquerda |
| Seta para direita  | Mover para direita  |
| D                  | Mover para direita  |
| Espaço             | Atirar              |
| R                  | Restart             |
| F                  | Fullscreen          |
| F11                | Fullscreen          |

Tem algumas teclas com funções que ajudaram durante o desenvolvimento do jogo,
se você tiver curiosidade de testar, elas são as seguintes:

| Tecla | Ação                                                                     |
|:-----:|--------------------------------------------------------------------------|
| N     | Ganhar instantaneamente a fase                                           |
| G     | Perder instantaneamente                                                  |
| L     | Fechar jogo                                                              |
| C     | Ativa o modo de debug, mostrando os colisores e as flags em `game.state` |
| P     | Acelerar o jogo                                                          |

