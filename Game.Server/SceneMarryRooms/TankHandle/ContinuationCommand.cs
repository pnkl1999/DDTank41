using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using System.Reflection;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    [MarryCommandAttbute(3)]
	public class ContinuationCommand : IMarryCommandHandler
    {
        protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentMarryRoom == null)
			{
				return false;
			}
			if (player.PlayerCharacter.ID != player.CurrentMarryRoom.Info.GroomID && player.PlayerCharacter.ID != player.CurrentMarryRoom.Info.BrideID)
			{
				return false;
			}
			int num = packet.ReadInt();
			string[] array = GameProperties.PRICE_MARRY_ROOM.Split(',');
			if (array.Length < 3)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("MarryRoomCreateMoney node in configuration file is wrong");
				}
				return false;
			}
			int num2;
			switch (num)
			{
			case 2:
				num2 = int.Parse(array[0]);
				break;
			case 3:
				num2 = int.Parse(array[1]);
				break;
			case 4:
				num2 = int.Parse(array[2]);
				break;
			default:
				num2 = int.Parse(array[2]);
				num = 4;
				break;
			}
			if (player.PlayerCharacter.Money + player.PlayerCharacter.MoneyLock < num2)
			{
				player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyHandler.Msg1"));
				return false;
			}
			player.RemoveMoney(num2);
			CountBussiness.InsertSystemPayCount(player.PlayerCharacter.ID, num2, 0, 0, 0);
			player.CurrentMarryRoom.RoomContinuation(num);
			GSPacketIn packet2 = player.Out.SendContinuation(player, player.CurrentMarryRoom.Info);
			int playerId = ((player.PlayerCharacter.ID != player.CurrentMarryRoom.Info.GroomID) ? player.CurrentMarryRoom.Info.GroomID : player.CurrentMarryRoom.Info.BrideID);
			WorldMgr.GetPlayerById(playerId)?.Out.SendTCP(packet2);
			player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ContinuationCommand.Successed"));
			return true;
        }
    }
}
