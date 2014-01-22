{* UltraStar Deluxe - Karaoke Game
 *
 * UltraStar Deluxe is the legal property of its developers, whose names
 * are too numerous to list here. Please refer to the COPYRIGHT
 * file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 * $URL: https://ultrastardx.svn.sourceforge.net/svnroot/ultrastardx/trunk/src/screens/UScreenName.pas $
 * $Id: UScreenName.pas 1939 2009-11-09 00:27:55Z s_alexander $
 *}

unit UScreenName;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I switches.inc}

uses
  SysUtils,
  SDL,
  UDisplay,
  UFiles,
  UMenu,
  UMusic,
  UScreenScore,
  UScreenSing,
  UScreenTop5,
  UThemes;

type
  TScreenName = class(TMenu)
    public
      Goto_SingScreen: boolean; //If true then next Screen in SingScreen
      constructor Create; override;
      function ParseInput(PressedKey: cardinal; CharCode: UCS4Char; PressedDown: boolean): boolean; override;
      procedure OnShow; override;
      procedure SetAnimationProgress(Progress: real); override;

      procedure PlayerColorButton(K: integer; Interact: integer);
      function NoRepeatColors(ColorP: integer; Interaction: integer; Pos: integer):integer;
      procedure Refresh; 
  end;

var
  Num: array[0..5]of integer;

implementation

uses
  UCommon,
  UGraphic,
  UIni,
  ULanguage,
  UNote,
  USongs,
  UTexture,
  UUnicodeUtils;


function TScreenName.ParseInput(PressedKey: cardinal; CharCode: UCS4Char; PressedDown: boolean): boolean;
var
  I: integer;
  SDL_ModState: word;
begin
  Result := true;
  if (PressedDown) then
  begin // Key Down

    SDL_ModState := SDL_GetModState and (KMOD_LSHIFT + KMOD_RSHIFT
    + KMOD_LCTRL + KMOD_RCTRL + KMOD_LALT  + KMOD_RALT);

    // check normal keys
    if (IsPrintableChar(CharCode)) then
    begin
      Button[Interaction].Text[0].Text := Button[Interaction].Text[0].Text +
                                          UCS4ToUTF8String(CharCode);
      Exit;
    end;

    // check special keys
    case PressedKey of
      // Templates for Names Mod
      SDLK_F1:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[0] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[0];
         end;
      SDLK_F2:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[1] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[1];
         end;
      SDLK_F3:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[2] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[2];
         end;
      SDLK_F4:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[3] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[3];
         end;
      SDLK_F5:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[4] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[4];
         end;
      SDLK_F6:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[5] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[5];
         end;
      SDLK_F7:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[6] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[6];
         end;
      SDLK_F8:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[7] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[7];
         end;
      SDLK_F9:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[8] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[8];
         end;
      SDLK_F10:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[9] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[9];
         end;
      SDLK_F11:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[10] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[10];
         end;
      SDLK_F12:
       if (SDL_ModState = KMOD_LALT) then
         begin
           Ini.NameTemplate[11] := Button[Interaction].Text[0].Text;
         end
         else
         begin
           Button[Interaction].Text[0].Text := Ini.NameTemplate[11];
         end;

      SDLK_BACKSPACE:
        begin
          Button[Interaction].Text[0].DeleteLastLetter();
        end;

      SDLK_ESCAPE :
        begin
          Ini.SaveNames;
          AudioPlayback.PlaySound(SoundLib.Back);
          if GoTo_SingScreen then
            FadeTo(@ScreenSong)
          else
            FadeTo(@ScreenMain);
        end;

      SDLK_RETURN:
        begin
          for I := 1 to 6 do
          begin
            Ini.Name[I-1] := Button[I-1].Text[0].Text;
            Ini.PlayerColor[I-1] := Num[I-1];
            Ini.SingColor[I-1] := Num[I-1];
          end;

          Ini.SaveNames;
          Ini.SavePlayerColors;

          LoadPlayersColors;
          Theme.ThemeScoreLoad;

          // Reload ScreenSing and ScreenScore because of player colors
          // TODO: do this better
          ScreenScore.Free;
          ScreenSing.Free;

          ScreenScore := TScreenScore.Create;
          ScreenSing  := TScreenSing.Create;
          //

          AudioPlayback.PlaySound(SoundLib.Start);

          if GoTo_SingScreen then
          begin
            //if (CatSongs.Song[ScreenSong.Interaction].isDuet and ((PlayersPlay=1) or
            //     (PlayersPlay=3) or (PlayersPlay=6))) then
            //    ScreenPopupError.ShowPopup(Language.Translate('SING_ERROR_DUET_NUM_PLAYERS'))
            //else
            //begin
              FadeTo(@ScreenSing);
              GoTo_SingScreen := false;
            //end
          end
          else
          begin
            FadeTo(@ScreenLevel);
            GoTo_SingScreen := false;
          end;
        end;

      // Up and Down could be done at the same time,
      // but I don't want to declare variables inside
      // functions like this one, called so many times
      SDLK_DOWN:
      begin
        if (SDL_ModState = KMOD_LCTRL) then
        begin
          Num[Interaction] := Num[Interaction]-1;
          Num[Interaction] := NoRepeatColors(Num[Interaction],Interaction,-1);
          PlayerColorButton(Num[Interaction], Interaction);
        end
        else
        begin
          if (SDL_ModState = KMOD_LSHIFT) then
          begin
           if (Ini.Players>0) then
             Dec(Ini.Players);

            if (Ini.Players >= 0) and (Ini.Players <= 3) then PlayersPlay := Ini.Players + 1;
            if (Ini.Players = 4) then PlayersPlay := 6;

            Refresh;
          end
          else
            InteractPrev;
        end;
      end;
      SDLK_UP:
      begin
       if (SDL_ModState = KMOD_LCTRL) then
       begin
         Num[Interaction] := Num[Interaction]+1;
         Num[Interaction] := NoRepeatColors(Num[Interaction],Interaction,1);
         PlayerColorButton(Num[Interaction], Interaction);
       end
       else
       begin
         if (SDL_ModState = KMOD_LSHIFT) then
         begin
            if (Ini.Players<4) then
              Inc(Ini.Players);

            if (Ini.Players >= 0) and (Ini.Players <= 3) then PlayersPlay := Ini.Players + 1;
            if (Ini.Players = 4) then PlayersPlay := 6;

            Refresh;
          end
          else
           InteractPrev;
        end;
      end;

      SDLK_RIGHT: InteractNext;
      SDLK_LEFT: InteractPrev;

    end;
  end;
end;

procedure TScreenName.Refresh;
var
  I:    integer;
begin
  for I := 1 to PlayersPlay do
  begin
    if (Ini.PlayerColor[I-1] > 0) then
      Num[I-1] := NoRepeatColors(Ini.PlayerColor[I-1], I-1, 1)
    else
      Num[I-1] := NoRepeatColors(1, I-1, 1);

    PlayerColorButton(Num[I-1], I-1);

    Button[I-1].Visible := true;
    Button[I-1].Selectable := true;
  end;

  for I := PlayersPlay+1 to 6 do
  begin
    Button[I-1].Visible := false;
    Button[I-1].Selectable := false;
  end;

  Interaction := 0;
end;

function TScreenName.NoRepeatColors(ColorP:integer; Interaction:integer; Pos:integer):integer;
var
  Z:integer;
begin

  if (ColorP >= 10) then
    ColorP := NoRepeatColors(1, Interaction, Pos);

  if (ColorP <= 0) then
    ColorP := NoRepeatColors(9, Interaction, Pos);

  for Z := 0 to PlayersPlay-1 do
  begin
    if Z <> Interaction then
    begin
     if (Num[Z] = ColorP) then
       ColorP := NoRepeatColors(ColorP + Pos, Interaction, Pos)
    end;
  end;

  Result := ColorP;

end;

procedure TScreenName.PlayerColorButton(K: integer; Interact: integer);
var
  Col, DesCol: TRGB;
begin

  Col := GetPlayerColor(K);

  Button[Interact].SelectColR:= Col.R;
  Button[Interact].SelectColG:= Col.G;
  Button[Interact].SelectColB:= Col.B;

  DesCol := GetPlayerLightColor(K);

  Button[Interact].DeselectColR:= DesCol.R;
  Button[Interact].DeselectColG:= DesCol.G;
  Button[Interact].DeselectColB:= DesCol.B;

  Interaction := Interact;

end;

constructor TScreenName.Create;
var
  I:    integer;
begin
  inherited Create;

  LoadFromTheme(Theme.Name);

  for I := 1 to 6 do
    AddButton(Theme.Name.ButtonPlayer[I]);

  Interaction := 0;
end;

procedure TScreenName.OnShow;
var
  I:    integer;
begin
  inherited;

  for I := 1 to 6 do
    Button[I-1].Text[0].Text := Ini.Name[I-1];

  // Player Colors
  for I := 1 to PlayersPlay do
  begin
    if (Ini.PlayerColor[I-1] > 0) then
      Num[I-1] := NoRepeatColors(Ini.PlayerColor[I-1], I-1, 1)
    else
      Num[I-1] := NoRepeatColors(1, I-1, 1);

    PlayerColorButton(Num[I-1], I-1);

    Button[I-1].Visible := true;
    Button[I-1].Selectable := true;
  end;

  for I := PlayersPlay+1 to 6 do
  begin
    Button[I-1].Visible := false;
    Button[I-1].Selectable := false;
  end;

  Interaction := 0;

end;

procedure TScreenName.SetAnimationProgress(Progress: real);
var
  I:    integer;
begin
  for I := 1 to 6 do
    Button[I-1].Texture.ScaleW := Progress;
end;

end.