using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_INVITE_DELETE)]
	public class ConsortiaInviteDelete : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			bool val = false;
			string translateId = "ConsortiaInviteDeleteHandler.Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				if (consortiaBussiness.DeleteConsortiaInviteUsers(num, Player.PlayerCharacter.ID))
				{
					translateId = "ConsortiaInviteDeleteHandler.Success";
					val = true;
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(13);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(translateId));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
