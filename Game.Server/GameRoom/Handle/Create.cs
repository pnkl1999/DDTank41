using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Buffer;
using Game.Server.Packets;
using Game.Server.Rooms;
using System;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute((byte)GameRoomPackageType.GAME_ROOM_CREATE)]
	public class Create : IGameRoomCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			byte roomType = packet.ReadByte();
			byte timeType = packet.ReadByte();
			string name = packet.ReadString();
			string password = packet.ReadString();
            if ((eRoomType)roomType == eRoomType.WordBossFight)
            {
                if (!RoomMgr.WorldBossRoom.WorldOpen || RoomMgr.WorldBossRoom.Blood <= 0)
                {
                    Player.CurrentRoom.RemovePlayerUnsafe(Player);
                    return false;
                }

                double addTime = GetTimeDelay(Player.FightPower);
                int timeLeft = DateTime.Compare(Player.LastEnterWorldBoss.AddSeconds(addTime), DateTime.Now);
                if (timeLeft > 0)
                {
                    Player.Out.SendMessage(eMessageType.Normal,
                        LanguageMgr.GetTranslation("GameRoomCreate.Msg2", timeLeft));
                    return false;
                }

                Player.LastEnterWorldBoss = DateTime.Now;
                Player.WorldbossBood = RoomMgr.WorldBossRoom.Blood;
                AbstractBuffer buffer = BufferList.CreatePayBuffer((int)BuffType.WorldBossHP, 50000, 10);
                if (buffer != null)
                {
                    buffer.Start(Player);
                }

                buffer = BufferList.CreatePayBuffer((int)BuffType.WorldBossAddDamage, 30000, 1);
                buffer?.Start(Player);
            }
            if (Player.MainWeapon == null)
            {
                Player.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, "Không mang vũ khí, không thể tham gia.");
                return false;
            }
            RoomMgr.CreateRoom(Player, name, password, (eRoomType)roomType, timeType);
			return true;
        }

        public double GetTimeDelay(int fightPower)
        {
            if (fightPower < 1000000)
                return 45.0;
            if (fightPower < 2000000)
                return 120.0;
            if (fightPower < 4000000)
                return 180.0;
            if (fightPower < 6000000)
                return 240.0;
            if (fightPower < 8000000)
                return 300.0;
            return 600;
        }
    }
}
