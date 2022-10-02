using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.NEWTITLE_CARD, "客户端日记")]
	public class NewTitleCardHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			eBageType bag = (eBageType)packet.ReadByte();
			int place = packet.ReadInt();
			ItemInfo item = client.Player.GetItemAt(bag, place);
			if (item == null)
			{
				//client.Player.SendMessage("Vật phẩm không tồn tại.");
				client.Player.SendMessage(LanguageMgr.GetTranslation("NewTitleCardHandler.ItemNotFound"));
			}
			else
			{
				NewTitleInfo title = NewTitleMgr.FindNewTitle(item.Template.Property1);
				if (title == null)
				{
					//client.Player.SendMessage("Danh hiệu chưa mở.");
					client.Player.SendMessage(LanguageMgr.GetTranslation("NewTitleCardHandler.TitleNotFound"));
				}
				else if (client.Player.RemoveCountFromStack(item, 1))
				{
					client.Player.Rank.AddNewRank(title.ID, item.Template.Property2);
					client.Player.EquipBag.UpdatePlayerProperties();
					GameServer.Instance.LoginServer.SendPacket(WorldMgr.SendSysNotice($"[{client.Player.ZoneName}] Chúc mừng người chơi [{client.Player.PlayerCharacter.NickName}] Vừa nhận được danh hiệu ~{title.Name}~"));
				}
				else
				{
					//client.Player.SendMessage("Xử lý dữ liệu thất bại. Vui lòng thử lại sau.");
					client.Player.SendMessage(LanguageMgr.GetTranslation("NewTitleCardHandler.RemoveItemError"));
				}
			}
			return 0;
        }
    }
}
