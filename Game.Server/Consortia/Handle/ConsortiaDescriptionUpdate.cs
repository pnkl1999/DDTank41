using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using System.Text;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE)]
	public class ConsortiaDescriptionUpdate : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			string text = packet.ReadString();
			if (Encoding.Default.GetByteCount(text) > 300)
			{
				Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ConsortiaDescriptionUpdateHandler.Long"));
				return 1;
			}
			bool val = false;
			string msg = "ConsortiaDescriptionUpdateHandler.Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				if (consortiaBussiness.UpdateConsortiaDescription(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, text, ref msg))
				{
					msg = "ConsortiaDescriptionUpdateHandler.Success";
					val = true;
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(14);
			gSPacketIn.WriteString(text);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
