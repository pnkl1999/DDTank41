using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Packets;
using Game.Server.Rooms;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute((byte)GameRoomPackageType.GAME_START)]
    public class GameStart : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            BaseRoom currentRoom = Player.CurrentRoom;
            if (currentRoom != null && currentRoom.Host == Player)
            {
                if (currentRoom.AvgLevel == 0)
                {
                    currentRoom.UpdateAvgLevel();
                }
                List<GamePlayer> players = currentRoom.GetPlayers();
                bool flag = false;
                foreach (GamePlayer player in players)
                {
                    if (player.MainWeapon == null)
                    {
                        Player.SendMessage(eMessageType.SYS_NOTICE, "Có thành viên hoặc khán giả không mang vũ khí, không thể bắt đầu!");
                        //player.SendMessage(eMessageType.SYS_NOTICE, "Không mang vũ khí, không thể bắt đầu!");
                        Player.CurrentRoom.IsPlaying = false;
                        Player.CurrentRoom.SendCancelPickUp();
                        return true;
                    }
                    if (player.isPlayerWarrior() && currentRoom.RoomType != eRoomType.Freedom)
                    {
                        Player.SendMessage(eMessageType.SYS_NOTICE, "Có thành viên là tài khoản thi đấu, không thể bắt đầu.");
                        Player.CurrentRoom.IsPlaying = false;
                        Player.CurrentRoom.SendCancelPickUp();
                        return true;
                    }    
                }

                if (!Player.isPassCheckCode() && currentRoom.AvgLevel > 14 && currentRoom.RoomType == eRoomType.Match)
                {
                    Player.CurrentRoom.IsPlaying = false;
                    Player.CurrentRoom.SendCancelPickUp();
                    Player.ShowCheckCode();
                    return true;
                }
                
                if (currentRoom.RoomType == eRoomType.FightLab && !Player.IsFightLabPermission(currentRoom.MapId, currentRoom.HardLevel))
                {
                    Player.SendMessage("Lỗi không thể tham gia.");
                    flag = true;
                }

                if (currentRoom.RoomType == eRoomType.Dungeon && !Player.IsPvePermission(currentRoom.MapId, currentRoom.HardLevel))
                {
                    Player.SendMessage(LanguageMgr.GetTranslation("GameStart.Msg1"));
                    flag = true;
                }
                else
                {
                    if (currentRoom.MapId == 13)
                    {
                        var tempIdTicket = currentRoom.GetDungeonTicketId(currentRoom.HardLevel);
                        ItemInfo info = Player.GetItemByTemplateID(tempIdTicket);
                        if (info == null)
                        {
                            foreach (GamePlayer p in players)
                            {
                                p.SendMessage(string.Format("Yêu cầu chủ phòng có vé để tham gia!"));
                                return true;
                            }
                        }

                        //Player.PropBag.RemoveTemplate(tempIdTicket, 1);
                        Player.RemoveTemplate(tempIdTicket, 1);
                    }
                }
                if (!flag)
                {
                    foreach (GamePlayer item in players)
                    {
                        if (item != null && !item.IsViewer && !item.isPlayerWarrior())
                        {
                            item.PetBag.ReduceHunger();
                        }
                    }
                    RoomMgr.StartGame(Player.CurrentRoom);
                }
                if (flag)
                {
                    Player.CurrentRoom.IsPlaying = false;
                    Player.CurrentRoom.SendCancelPickUp();
                }
            }
            return true;
        }
    }
}
