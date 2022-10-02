using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(131, "场景用户离开")]
	public class LabyrinthHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			LabyrinthPackageType labyrinthPackageType = (LabyrinthPackageType)packet.ReadInt();
			int sType = 0;
			UserLabyrinthInfo userLabyrinthInfo = client.Player.Labyrinth ?? client.Player.LoadLabyrinth(sType);
			int iD = client.Player.PlayerCharacter.ID;
			switch (labyrinthPackageType)
			{
			case LabyrinthPackageType.DOUBLE_REWARD:
			{
				bool flag = packet.ReadBoolean();
				if (client.Player.PropBag.GetItemByTemplateID(0, 11916) == null)
				{
					return 0;
				}
				if (flag && !userLabyrinthInfo.isDoubleAward && client.Player.RemoveTemplate(11916, 1))
				{
					userLabyrinthInfo.isDoubleAward = flag;
				}
				client.Player.Out.SendLabyrinthUpdataInfo(iD, userLabyrinthInfo);
				break;
			}
			case LabyrinthPackageType.REQUEST_UPDATE:
				if (userLabyrinthInfo.isValidDate())
				{
					userLabyrinthInfo.completeChallenge = true;
					userLabyrinthInfo.accumulateExp = 0;
					userLabyrinthInfo.isInGame = false;
					userLabyrinthInfo.currentFloor = 1;
					userLabyrinthInfo.tryAgainComplete = true;
					userLabyrinthInfo.LastDate = DateTime.Now;
					userLabyrinthInfo.ProcessAward = client.Player.InitProcessAward();
				}
				client.Player.CalculatorClearnOutLabyrinth();
				client.Player.Out.SendLabyrinthUpdataInfo(iD, userLabyrinthInfo);
				break;
			case LabyrinthPackageType.CLEAN_OUT:
			{
				int warriorFamRaidDDTPrice = GameProperties.WarriorFamRaidDDTPrice;
				if (client.Player.PlayerCharacter.GiftToken < warriorFamRaidDDTPrice)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg1"));
					client.Player.Actives.StopCleantOutLabyrinth();
				}
				else
				{
					userLabyrinthInfo.isCleanOut = true;
					client.Player.RemoveGiftToken(warriorFamRaidDDTPrice);
					client.Player.Actives.CleantOutLabyrinth();
				}
				break;
			}
			case LabyrinthPackageType.SPEEDED_UP_CLEAN_OUT:
			{
				if (!userLabyrinthInfo.isCleanOut)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg2"));
					return 0;
				}
				int num2 = Math.Abs(userLabyrinthInfo.currentRemainTime / 60);
				int value2 = GameProperties.WarriorFamRaidPricePerMin * num2;
				if (client.Player.MoneyDirect(value2, IsAntiMult: false, false))
				{
					client.Player.Actives.SpeededUpCleantOutLabyrinth();
				}
				break;
			}
			case LabyrinthPackageType.STOP_CLEAN_OUT:
				client.Player.Actives.StopCleantOutLabyrinth();
				break;
			case LabyrinthPackageType.RESET_LABYRINTH:
				if (userLabyrinthInfo.tryAgainComplete)
				{
					userLabyrinthInfo.currentFloor = 1;
					userLabyrinthInfo.accumulateExp = 0;
					userLabyrinthInfo.tryAgainComplete = false;
					userLabyrinthInfo.ProcessAward = client.Player.InitProcessAward();
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg4"));
					client.Player.Out.SendLabyrinthUpdataInfo(iD, userLabyrinthInfo);
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg5"));
				}
				break;
			case LabyrinthPackageType.TRY_AGAIN:
			{
				int num = (packet.ReadBoolean() ? 1 : 0);
				packet.ReadBoolean();
				if (num != 0)
				{
					int value = client.Player.LabyrinthTryAgainMoney();
					if (client.Player.RemoveMoney(value) > 0)
					{
						userLabyrinthInfo.completeChallenge = true;
						userLabyrinthInfo.isInGame = true;
						client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg6"));
					}
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Labyrinth.Msg4"));
				}
				break;
			}
			default:
				Console.WriteLine("LabyrinthPackageType: " + labyrinthPackageType);
				break;
			}
			return 0;
        }
    }
}
