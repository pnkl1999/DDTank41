using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;
using log4net;
using System;
using System.Reflection;

namespace Game.Server.GameRoom.Handle
{
    [GameRoomHandleAttbute(15)]
	public class GamePlayerStateChange : IGameRoomCommandHadler
    {
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.MainWeapon == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
				return false;
			}
			if (Player.CurrentRoom != null)
			{
				byte state = packet.ReadByte();
				RoomMgr.UpdatePlayerState(Player, state);
				log.Error(string.Concat(Player.PlayerCharacter.NickName, " -> to State ", state.ToString()));
			}
			return true;
        }
    }
}
