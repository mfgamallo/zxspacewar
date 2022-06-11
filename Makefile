generate:
	@echo "Generating TAP file..."
	pasmo --tapbas main.asm main.tap

clean:
	@echo "Cleaning..."
	rm main.tap
