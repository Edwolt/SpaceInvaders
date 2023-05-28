# Need to downlaod binaries from the löve site
# And put on folders build/win32 and build/win64 (unziped)

NAME:= SpaceInvaders
LUA := $(wildcard *.lua modules/*.lua objects/*.lua utils/*.lua)
IMG := $(wildcard assets/* )
CODE := $(LUA) $(IMG)
ALL := $(wildcard * assets/* modules/* objects/* utils/* screenshots/*)

del_highscore:
	rm -f highscore.txt

$(NAME).zip: $(ALL) del_highscore
	rm -f $(NAME).zip
	zip $(NAME).zip $(ALL) \*.zip \*.love

$(NAME).love: $(CODE) del_highscore
	rm -f $(NAME).love
	zip $(NAME).love $(CODE)

$(NAME)_win32.zip: $(NAME).love
	rm -f $(NAME)_win32.zip
	cat build/win32/love.exe $(NAME).love > build/win32/$(NAME).exe

$(NAME)_win64.zip: $(NAME).love
	rm -f $(NAME)_win64.zip
	cat build/win64/love.exe $(NAME).love > build/win64/$(NAME).exe

$(NAME)_dist.zip: $(NAME)_win64.zip $(NAME)_win32.zip $(NAME).love
	rm -f $(NAME)_dist.zip
	cp $(NAME).love build/$(NAME).love
	cp INSTRUCOES.md build/INSTRUCOES.md
	zip $(NAME)_dist.zip -r build/*

all: $(NAME)_dist.zip $(NAME).zip

clean:
	rm -f $(NAME).zip
	rm -f $(NAME).love
	rm -f $(NAME)_win32.zip
	rm -f $(NAME)_win64.zip
	rm -f $(NAME)_dist.zip
