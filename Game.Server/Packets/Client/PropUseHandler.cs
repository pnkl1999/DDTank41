using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bussiness;
namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.PROP_USE, "场景用户离开")]
    public class PropUseHandler : IPacketHandler
    {
        private Random rand = new Random();
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            eBageType bagType = (eBageType)packet.ReadInt();
            int place = packet.ReadInt();
            PlayerInventory invent = client.Player.GetInventory(bagType);
            if (invent != null)
            {
                ItemInfo prop = invent.GetItemAt(place);
                if (prop != null)
                {
                    int count = packet.ReadInt();
                    for (int i = 0; i < count; i++)
                    {
                        int templateid = packet.ReadInt();
                        switch (templateid)
                        {
                            case 201316:// code ga hanh
                                UserChickActiveInfo chickInfo = client.Player.Actives.GetChickActiveData();
                                if (chickInfo.IsKeyOpened == 0 && prop != null && prop.Count >= 1)
                                {
                                    invent.RemoveCountFromStack(prop, 1);
                                    chickInfo.Active((client.Player.PlayerCharacter.Grade > 15) ? 2 : 1);
                                    client.Player.Actives.SaveChickActiveData(chickInfo);
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("PropUseHandler.ChickActivation.Success"));
                                }
                                else
                                {
                                    client.Player.SendMessage(LanguageMgr.GetTranslation("PropUseHandler.ChickActivation.Fail"));
                                }
                                break;
                            case 11963://lì xì phát tài
                                int token = rand.Next(1, 1000);
                                client.Player.AddGiftToken(token);
                                client.Player.SendMessage(LanguageMgr.GetTranslation("PropUseHandler.GiftToken", token));
                                invent.RemoveCountFromStack(prop, 1);
                                break;
                        }
                    }
                    int payType = packet.ReadInt();
                    bool unk = packet.ReadBoolean();
                }
            }
            return 0;
        }
    }
}
