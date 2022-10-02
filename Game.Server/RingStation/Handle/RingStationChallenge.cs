using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_CHALLENGE)]
    public class RingStationChallenge : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            int playerid = packet.ReadInt();
            int rank = packet.ReadInt();
            UserRingStationInfo currenrRing = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
            if (currenrRing.CanChallenge())
            {
                if (currenrRing.ChallengeNum > 0)
                {
                    bool isBoot = false;
                    UserRingStationInfo callengeRing =
                        RingStationMgr.GetRingStationChallenge(playerid, rank, ref isBoot);
                    if (!callengeRing.OnFight)
                    {
                        //Player.DareFlag = new RingstationBattleFieldInfo();
                        //Player.DareFlag.DareFlag = true;
                        //Player.DareFlag.UserID = Player.PlayerCharacter.ID;
                        //Player.DareFlag.UserName = callengeRing.Info.NickName;
                        //Player.DareFlag.BattleTime = DateTime.Now;
                        //Player.DareFlag.Level = currenrRing.Rank;
                        //if (!isBoot)
                        //{
                        //    Player.SuccessFlag = new RingstationBattleFieldInfo();
                        //    Player.SuccessFlag.DareFlag = false;
                        //    Player.SuccessFlag.UserID = callengeRing.Info.ID;
                        //    Player.SuccessFlag.UserName = Player.PlayerCharacter.NickName;
                        //    Player.SuccessFlag.BattleTime = DateTime.Now;
                        //    Player.SuccessFlag.Level = callengeRing.Rank;
                        //}

                        //RoomMgr.CreateRingStationRoom(Player, callengeRing);
                        ////callengeRing.OnFight = true;
                        //RingStationMgr.UpdateRingStationFight(callengeRing);
                    }
                    else
                    {
                        Player.SendMessage(LanguageMgr.GetTranslation("RingStationChallenge.OnFight",
                            callengeRing.Info.NickName));
                    }
                }
                else
                {
                    Player.SendMessage(LanguageMgr.GetTranslation("RingStationChallenge.Fail"));
                }
            }
            else
            {
                Player.SendMessage(LanguageMgr.GetTranslation("RingStationFightFlag.CdFail"));
            }

            return true;
        }
    }
}