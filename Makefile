# Makefile para o Processador 5 "Calculadora Programável"
# Prof. Juliano (adaptado por microprocessador)

# --- Configuração ---
GHDL = ghdl
# Flags do GHDL (use --std=08 ou superior)
GHDL_FLAGS = --std=08

# Visualizador de ondas
WAVE_VIEWER = gtkwave

# Arquivo Top-Level do Testbench (Lab 5)
TOP_LEVEL = processador_tb

# Arquivos de saída
WAVE_FILE = lab6.ghw
# Arquivo de configuração do GTKWave (para salvar seus sinais)
SAVE_FILE = lab6.gtkw

# --- Diretórios do Projeto ---
DIR_DATAPATH = banco_regs+ula
DIR_CONTROL = rom

# --- Alvos Principais ---
.PHONY: all compile run view clean

# Alvo padrão: compila e roda
all: run

# 1. Compila (Analisa) todos os arquivos .vhd na ordem de dependência
compile:
	@echo "== 1. Compilando Componentes Base (Datapath) =="
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_DATAPATH)/reg16bits.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_DATAPATH)/flags.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_DATAPATH)/ula.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_DATAPATH)/banco_registradores.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_DATAPATH)/top_level_banco_ula.vhd
	
	@echo "== 2. Compilando Componentes Base (Controle) =="
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_CONTROL)/pc.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_CONTROL)/maq_estados.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_CONTROL)/rom.vhd
	$(GHDL) -a $(GHDL_FLAGS) $(DIR_CONTROL)/unidade_controle.vhd
	
	@echo "== 3. Compilando Top-Level (Processador) =="
	$(GHDL) -a $(GHDL_FLAGS) processador.vhd
	
	@echo "== 4. Compilando Testbench =="
	$(GHDL) -a $(GHDL_FLAGS) processador_tb.vhd
	@echo "== Compilação Concluída =="

# 2. Roda a simulação
run: compile
	@echo "== Rodando Simulação ( $(TOP_LEVEL) ) =="
	$(GHDL) -r $(GHDL_FLAGS) $(TOP_LEVEL) --wave=$(WAVE_FILE)
	@echo "== Simulação Concluída. Arquivo gerado: $(WAVE_FILE) =="

# 3. Visualiza os resultados
view:
	@echo "== Abrindo $(WAVE_VIEWER) =="
	$(WAVE_VIEWER) $(WAVE_FILE) $(SAVE_FILE)

# 4. Limpa os arquivos gerados
clean:
	@echo "== Limpando arquivos de simulação =="
	$(GHDL) --remove
	rm -f $(WAVE_FILE)
	rm -f *.o
	@echo "== Limpeza Concluída =="