using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute((byte)GameRoomPackageType.GAME_ROOM_LOGIN)]
    public class Login : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            bool isInvite = packet.ReadBoolean();
            int type = packet.ReadInt();
            int num = packet.ReadInt();
            int roomId = -1;
            string pwd = "";
            if (num == -1)
            {
                roomId = packet.ReadInt();
                pwd = packet.ReadString();
            }
            //RoomMgr.EnterRoom(Player, roomId, pwd, type, type);
            GamePlayer m_player = Player;
            int m_roomId = roomId;
            string m_pwd = pwd;
            int m_hallType = type;
            bool m_isInvite = isInvite;
            bool flag = true;

            if (!m_player.IsActive)
            {
                m_player.Out.SendRoomLoginResult(false);
                return false;
            }
            if (m_player.MainWeapon == null)
            {
                m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, "Không mang vũ khí, không thể tham gia.");
                m_player.Out.SendRoomLoginResult(false);
                return false;
            }
            if (m_player.CurrentRoom != null)
                m_player.CurrentRoom.RemovePlayerUnsafe(m_player);
            BaseRoom[] rooms = RoomMgr.Rooms;
            BaseRoom randomRoom;
            if (m_roomId == -1)
            {
                randomRoom = FindRandomRoom(rooms, m_hallType, m_player);
                if (randomRoom == null)
                {
                    m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.noroom"));
                    m_player.Out.SendRoomLoginResult(false);

                }
            }
            else
            {
                if (m_roomId > rooms.Length || m_roomId <= 0)
                {
                    m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.noexist"));
                    m_player.Out.SendRoomLoginResult(false);

                }
                randomRoom = rooms[m_roomId - 1];
            }
            if (randomRoom != null)
            {
                if (!randomRoom.IsUsing)
                {
                    m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.noexist"));
                    m_player.Out.SendRoomLoginResult(false);

                }
                else
                {
                    if (randomRoom.IsPlaying)
                    {
                        if (randomRoom.Game is PVEGame)
                        {
                            if ((randomRoom.Game as PVEGame).GameState != eGameState.SessionPrepared || !m_isInvite)
                            {
                                m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.start"));
                                flag = false;
                                //m_player.Out.SendRoomLoginResult(false);

                            }
                        }
                        else
                        {
                            m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.start"));
                            flag = false;
                            //m_player.Out.SendRoomLoginResult(false);

                        }
                    }
                    if (flag)
                    {
                        if (randomRoom.PlayerCount == randomRoom.PlacesCount)
                        {
                            //flag = false;
                            //m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.full"));
                            if (randomRoom.CanAddViewPlayer())
                            {
                                RoomMgr.WaitingRoom.RemovePlayer(m_player);
                                m_player.Out.SendRoomLoginResult(true);
                                m_player.Out.SendRoomCreate(randomRoom);
                                if (randomRoom.AddPlayerUnsafe(m_player))
                                    randomRoom.Game?.AddPlayer(m_player);
                                RoomMgr.WaitingRoom.SendUpdateCurrentRoom(randomRoom);
                                m_player.Out.SendGameRoomSetupChange(randomRoom);
                                randomRoom.UpdatePlayerState(m_player, 1, false);
                                return true;
                            }
                            else
                            {
                                m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("Phòng đã đầy!"));
                                flag = false;

                            }
                        }
                        else if (!randomRoom.NeedPassword || randomRoom.Password == m_pwd)
                        {
                            if (randomRoom.Game == null || randomRoom.Game.CanAddPlayer())
                            {
                                if (randomRoom.RoomType == eRoomType.Dungeon && (eLevelLimits)randomRoom.LevelLimits > randomRoom.GetLevelLimit(m_player))
                                {
                                    m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("EnterRoomAction.level"));
                                    flag = false;
                                }
                                else
                                {
                                    RoomMgr.WaitingRoom.RemovePlayer(m_player);
                                    m_player.Out.SendRoomLoginResult(true);
                                    m_player.Out.SendRoomCreate(randomRoom);
                                    if (randomRoom.AddPlayerUnsafe(m_player) && randomRoom.Game != null)
                                        randomRoom.Game.AddPlayer((IGamePlayer)m_player);
                                    RoomMgr.WaitingRoom.SendUpdateRoom(m_player);
                                    m_player.Out.SendGameRoomSetupChange(randomRoom);
                                    return true;
                                }
                            }
                            else
                            {
                                flag = false;
                            }
                        }
                        else
                        {
                            m_player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, !randomRoom.NeedPassword || !string.IsNullOrEmpty(m_pwd) ? LanguageMgr.GetTranslation("EnterRoomAction.passworderror") : LanguageMgr.GetTranslation("EnterRoomAction.EnterPassword"));
                            flag = false;

                        }
                    }
                }
            }
            if (!flag)
            {
                m_player.Out.SendRoomLoginResult(false);
            }
            return true;
        }

        private BaseRoom FindRandomRoom(BaseRoom[] rooms, int m_type, GamePlayer m_player)
        {
            for (int index = 0; index < rooms.Length; ++index)
            {
                if (rooms[index].PlayerCount > 0 && rooms[index].CanAddPlayer() && (!rooms[index].NeedPassword && !rooms[index].IsPlaying) && rooms[index].RoomType != eRoomType.Freshman)
                {
                    if (10 != m_type)
                    {
                        if (rooms[index].RoomType == (eRoomType)m_type)
                            return rooms[index];
                    }
                    else if (rooms[index].RoomType == (eRoomType)m_type && (eLevelLimits)rooms[index].LevelLimits < rooms[index].GetLevelLimit(m_player))
                        return rooms[index];
                }
            }
            return (BaseRoom)null;
        }
    }
}
