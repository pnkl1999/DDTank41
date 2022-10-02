using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LEFT_GUN_ROULETTE_SOCKET, "物品炼化")]
    public class LeftGunHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //if (client.Player.Extra.Info.LeftRoutteCount > 0 && client.Player.Extra.Info.LeftRoutteRate <= 0f)
            //{
            //    RandomSafe rd = new RandomSafe();
            //    //float[] Rate = new float[] { 0.0003f, 0.0002f, 0.0001f, 0.001f, 0.002f };
            //    string[] Rate = GameProperties.LeftRouterRateData.Split('|');
            //    float NeedRate = 0f;
            //    int rdsafe = rd.Next(10000);
            //    if (rdsafe < 600)
            //    {
            //        NeedRate = float.Parse(Rate[4]);
            //    }
            //    else if (rdsafe < 1500)
            //    {
            //        NeedRate = float.Parse(Rate[3]);
            //    }
            //    else if (rdsafe < 4000)
            //    {
            //        NeedRate = float.Parse(Rate[2]);
            //    }
            //    else if (rdsafe < 7000)
            //    {
            //        NeedRate = float.Parse(Rate[1]);
            //    }
            //    else if (rdsafe < 9000)
            //    {
            //        NeedRate = float.Parse(Rate[0]);
            //    }
            //    if (NeedRate > 0f)
            //    {
            //        client.Player.Extra.Info.LeftRoutteCount--;
            //        client.Player.Extra.Info.LeftRoutteRate = NeedRate;
            //    }
            //    client.Out.SendLeftRouleteResult(client.Player.Extra.Info);
            //    return 0;
            //}
            //return 0;

            int cmd = packet.ReadInt();
            RandomSafe rand = new RandomSafe();
            switch (cmd)
            {
                case 1:
                    string[] rates = GameProperties.LeftRouterRateData.Split('|');
                    float result = 0f;
                    int randNum = rand.Next(55);
                    if (randNum < 15)
                    {
                        result = float.Parse(rates[0]);
                    }
                    else if (randNum < 25)
                    {
                        result = float.Parse(rates[1]);
                    }
                    else if (randNum < 35)
                    {
                        result = float.Parse(rates[2]);
                    }
                    else if (randNum < 45)
                    {
                        result = float.Parse(rates[3]);
                    }
                    else if (randNum <= 55)
                    {
                        result = float.Parse(rates[4]);
                    }

                    if (result > 0f)
                    {
                        client.Player.Extra.Info.LeftRoutteCount--;
                        client.Player.Extra.Info.LeftRoutteRate = result;
                    }
                    //count = 0;

                    client.Out.SendLeftRouleteResult(client.Player.Extra.Info);
                    return 0;
                    //break;
            }
            return 0;
        }
    }
}
