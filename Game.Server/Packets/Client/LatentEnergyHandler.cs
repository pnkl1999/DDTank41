using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System;
namespace Game.Server.Packets.Client
{
	[PacketHandler((byte)ePackageType.LATENT_ENERGY, "场景用户离开")]
	public class LatentEnergyHandler : IPacketHandler
	{
		public static ThreadSafeRandom random = new ThreadSafeRandom();
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int type = packet.ReadByte();
			int BagType = packet.ReadInt();
			int Place = packet.ReadInt();
			ItemInfo equipCell = client.Player.GetItemAt((eBageType)BagType, Place);
			if (!equipCell.CanLatentEnergy())
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("LatentEnergyHandler.Msg1"));
				return 0;
			}
			PlayerInventory inventory = client.Player.GetInventory((eBageType)BagType);
			string msg = "Kích hoạt tiềm năng thành công!";
			GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LATENT_ENERGY, client.Player.PlayerCharacter.ID);
			if (type == 1)
			{
				int temBagType = packet.ReadInt();
				int temPlace = packet.ReadInt();
				ItemInfo itemCell = client.Player.GetItemAt((eBageType)temBagType, temPlace);
				if (itemCell == null || itemCell.Count < 1 || itemCell.Template.Property1 != 101)
				{
					client.Out.SendMessage(eMessageType.Normal, "Vật phẩm không đủ.");
					return 0;
				}
				int CurStr = int.Parse(equipCell.latentEnergyCurStr.Split(',')[0]);
				ItemTemplateInfo Temp = itemCell.Template;
				if (equipCell.IsValidLatentEnergy() || CurStr >= Temp.Property3 - 5 || CurStr <= Temp.Property2 - 5)
				{
					equipCell.ResetLatentEnergy();
				}
				string tepmCurStr = LatentEnergyHandler.random.Next(Temp.Property2, Temp.Property3).ToString();
				for (int i = 1; i < 4; i++)
				{
					tepmCurStr = tepmCurStr + "," + LatentEnergyHandler.random.Next(Temp.Property2, Temp.Property3).ToString();
				}
				for (int z = 4; z < 7; z++)
				{
					tepmCurStr = tepmCurStr + "," + LatentEnergyHandler.random.Next(Temp.Property6, Temp.Property7).ToString();
				}
				if (equipCell.latentEnergyCurStr.Split(',')[0] == "0")
				{
					equipCell.latentEnergyCurStr = tepmCurStr;// "1,1,1,1";
				}
				equipCell.latentEnergyNewStr = tepmCurStr;
				equipCell.latentEnergyEndTime = DateTime.Now.AddDays(7.0);
				PlayerInventory storeBag = client.Player.GetInventory((eBageType)temBagType);
				storeBag.RemoveCountFromStack(itemCell, 1);
			}
			else
			{
				equipCell.latentEnergyCurStr = equipCell.latentEnergyNewStr;
				msg = "Cập nhật tiềm năng thành công!";
			}
			pkg.WriteInt(equipCell.Place);
			pkg.WriteString(equipCell.latentEnergyCurStr);
			pkg.WriteString(equipCell.latentEnergyNewStr);
			pkg.WriteDateTime(equipCell.latentEnergyEndTime);
			equipCell.IsBinds = true;
			inventory.UpdateItem(equipCell);
			client.Player.EquipBag.UpdatePlayerProperties();
			client.Out.SendTCP(pkg);
			client.Player.SendMessage(msg);
			return 0;
		}
	}
}
