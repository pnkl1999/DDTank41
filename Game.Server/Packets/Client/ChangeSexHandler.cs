using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;

namespace Game.Server.Packet.Client
{
    [PacketHandler(252, "场景用户离开")]
    public class ChangeSexHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn pkg)
        {
            int bageType = pkg.ReadByte();
            int slot = pkg.ReadInt();
            PlayerInventory inventory = client.Player.GetInventory((eBageType)bageType);
            ItemInfo itemAt = inventory.GetItemAt(slot);
            if (itemAt == null)
            {
                return 0;
            }
            if (itemAt.TemplateID == 11569)
            {
                using PlayerBussiness playerBussiness = new PlayerBussiness();
                PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(client.Player.PlayerCharacter.SpouseID);
                if (userSingleByUserID == null || userSingleByUserID.Sex == client.Player.PlayerCharacter.Sex)
                {
                    MarryApplyInfo marryApplyInfo = new MarryApplyInfo();
                    marryApplyInfo.UserID = client.Player.PlayerCharacter.SpouseID;
                    marryApplyInfo.ApplyUserID = client.Player.PlayerCharacter.ID;
                    marryApplyInfo.ApplyUserName = client.Player.PlayerCharacter.NickName;
                    marryApplyInfo.ApplyType = 3;
                    marryApplyInfo.LoveProclamation = "";
                    marryApplyInfo.ApplyResult = false;
                    int id = 0;
                    if (playerBussiness.SavePlayerMarryNotice(marryApplyInfo, 0, ref id))
                    {
                        GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(userSingleByUserID.ID);
                        client.Player.LoadMarryProp();
                    }
                    client.Player.QuestInventory.ClearMarryQuest();
                }
                bool newSex = ((!client.Player.PlayerCharacter.Sex) ? true : false);
                if (playerBussiness.ChangeSex(client.Player.PlayerCharacter.ID, newSex))
                {
                    inventory.RemoveCountFromStack(itemAt, 1);
                    client.Player.SendMessage(LanguageMgr.GetTranslation("ChangeSexHandlerHandler.Success"));
                }
                else
                {
                    client.Player.SendMessage(LanguageMgr.GetTranslation("ChangeSexHandlerHandler.Fail"));
                }
            }
            return 0;
        }
    }
}
