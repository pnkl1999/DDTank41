using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Buffer;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(99, "场景用户离开")]
    public class TexpHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int selectIndex = packet.ReadInt();
            int templateID = packet.ReadInt();
            int m_place = packet.ReadInt();
            string text = "HP";
            ItemInfo item = client.Player.StoreBag.GetItemAt(m_place);
            TexpInfo info = client.Player.PlayerCharacter.Texp;
            int oldExp = 0;
            if (item == null || info == null || item.TemplateID != templateID || client.Player.isPlayerWarrior())
            {
                return 0;
            }
            if (!item.isTexp())
            {
                return 0;
            }
            int limitCount = client.Player.PlayerCharacter.Grade;
            if (client.Player.PlayerCharacter.VIPLevel <= 2)
            {
                limitCount = limitCount * 2;
            }
            else
            {
                limitCount = limitCount * 3;
            }
            if (client.Player.UsePayBuff(BuffType.Train_Good))
            {
                AbstractBuffer ofType = client.Player.BufferList.GetOfType(BuffType.Train_Good);
                limitCount += ofType.Info.Value;
            }
            if (info.texpTaskDate.Date.AddDays(1.0).Date <= DateTime.Now.Date && info.texpCount >= limitCount)
            {
                info.texpCount = 0;
                info.texpTaskDate = DateTime.Now;
            }
            if (info.texpCount >= limitCount)
            {
                client.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("texpSystem.texpCountToplimit"));
            }
            else
            {
                client.Player.OnUsingItem(templateID, 1);
                client.Player.StoreBag.RemoveTemplate(templateID, 1);
                switch (selectIndex)
                {
                    case 0:
                        oldExp = info.hpTexpExp;
                        info.hpTexpExp += item.Template.Property2;
                        client.Player.OnUsingItem(45005, 1);
                        break;
                    case 1:
                        oldExp = info.attTexpExp;
                        info.attTexpExp += item.Template.Property2;
                        client.Player.OnUsingItem(45001, 1);
                        text = "Tấn Công";
                        break;
                    case 2:
                        oldExp = info.defTexpExp;
                        info.defTexpExp += item.Template.Property2;
                        client.Player.OnUsingItem(45002, 1);
                        text = "Phòng Thủ";
                        break;
                    case 3:
                        oldExp = info.spdTexpExp;
                        info.spdTexpExp += item.Template.Property2;
                        client.Player.OnUsingItem(45003, 1);
                        text = "Nhanh Nhẹn";
                        break;
                    case 4:
                        oldExp = info.lukTexpExp;
                        info.lukTexpExp += item.Template.Property2;
                        client.Player.OnUsingItem(45004, 1);
                        text = "May Mắn";
                        break;
                }
                info.texpCount++;
                info.texpTaskCount++;
                client.Player.PlayerCharacter.Texp = info;
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    db.UpdateUserTexpInfo(info);
                }
                client.Player.EquipBag.UpdatePlayerProperties();

            }
            return 0;
        }
    }
}
