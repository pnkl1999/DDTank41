using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Consortia.Handle
{
    [ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_TASK_RELEASE)]
    public class CConsortiaTask : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            Player.ConsortiaTask?.ProcessData(Player, packet);
            //Player.Out.SendMessage(eMessageType.GM_NOTICE, string.Format("Tính năng sứ mệnh guild đang được làm lại!!!"));
            return 0;
        }
    }
}
