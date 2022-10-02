using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_TRYIN_DEL)]
	public class ConsortiaTryinDel : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			bool val = false;
			string msg = "ConsortiaApplyAllyDeleteHandler.Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				if (consortiaBussiness.DeleteConsortiaApplyUsers(num, Player.PlayerCharacter.ID, Player.PlayerCharacter.ConsortiaID, ref msg))
				{
					msg = ((Player.PlayerCharacter.ID == 0) ? "ConsortiaApplyAllyDeleteHandler.Success" : "ConsortiaApplyAllyDeleteHandler.Success2");
					val = true;
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(5);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
