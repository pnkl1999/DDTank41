using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_BUYCOUNTORTIME)]
    public class RingStationBuyBattleCountOrTime : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            bool timeFlag = packet.ReadBoolean();
            bool isBand = packet.ReadBoolean();
            //Console.WriteLine("isBand: {0}, timeFlag:{1}", isBand, timeFlag);
            GSPacketIn pkg = new GSPacketIn((short) ePackageType.RING_STATION, Player.PlayerId);
            pkg.WriteByte((byte) RingStationPackageType.RINGSTATION_BUYCOUNTORTIME);
            UserRingStationInfo currentRing = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
            pkg.WriteBoolean(timeFlag);
            if (timeFlag)
            {
                if (false)
                {
                    pkg.WriteBoolean(true);
                    currentRing.ChallengeTime = DateTime.Now;
                    currentRing.ChallengeTime = DateTime.Now.AddMinutes(-1);
                    RingStationMgr.UpdateRingStationInfo(currentRing);
                    Player.SendMessage(LanguageMgr.GetTranslation("RingStationBuyBattleCountOrTime.ClearTime"));
                }
                else
                {
                    pkg.WriteBoolean(false);
                }

                Player.SendTCP(pkg);
            }
            else
            {
                if (false)
                {
                    if (currentRing.buyCount > 0)
                    {
                        currentRing.buyCount--;
                        currentRing.ChallengeNum++;
                        RingStationMgr.UpdateRingStationInfo(currentRing);
                        Player.SendMessage(LanguageMgr.GetTranslation("RingStationBuyBattleCountOrTime.BuyChallenge"));
                    }
                    else
                    {
                        Player.SendMessage(LanguageMgr.GetTranslation("RingStationBuyBattleCountOrTime.Limit"));
                    }

                    pkg.WriteInt(currentRing.buyCount); //_buyCount = _loc_2.readInt();
                    pkg.WriteInt(currentRing.ChallengeNum); //setChallengeNum(_loc_2.readInt());
                    Player.SendTCP(pkg);
                }
            }

            return true;
        }
    }
}