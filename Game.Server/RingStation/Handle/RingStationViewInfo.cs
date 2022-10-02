using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_VIEWINFO)]
    public class RingStationViewInfo : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            RingStationMgr.LoadRingStationInfo(Player.PlayerCharacter, (int) Player.GetBaseAttack(), (int) Player.GetBaseDefence());
            GSPacketIn pkg = new GSPacketIn((short) ePackageType.RING_STATION, Player.PlayerId);
            UserRingStationInfo currentRing = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
            if (currentRing.LastDate.Date < DateTime.Now.Date)
            {
                currentRing.LastDate = DateTime.Now;
                currentRing.ChallengeNum = RingStationMgr.ConfigInfo.ChallengeNum;
                currentRing.buyCount = RingStationMgr.ConfigInfo.buyCount;
                RingStationMgr.UpdateRingStationInfo(currentRing);
            }

            RingstationConfigInfo config = RingStationMgr.ConfigInfo;
            pkg.WriteByte((byte) RingStationPackageType.RINGSTATION_VIEWINFO);
            pkg.WriteInt(currentRing.Rank); //Rank
            pkg.WriteInt(currentRing.ChallengeNum); //ChallengeNum
            pkg.WriteInt(currentRing.buyCount); //buyCount
            pkg.WriteInt(config.buyPrice); //buyPrice
            pkg.WriteDateTime(currentRing.ChallengeTime); //setChallengeTime
            pkg.WriteInt(config.cdPrice); //cdPrice
            pkg.WriteInt(0);
            pkg.WriteString(currentRing.signMsg); //setSignText
            pkg.WriteInt(config.AwardNumByRank(currentRing.Rank)); //setAwardNum
            pkg.WriteDateTime(config.AwardTime); //setAwardTime
            pkg.WriteString(config.ChampionText); //setChampionText
            pkg.WriteBoolean(false); //Player.PlayerCharacter.isAttest
            pkg.WriteBoolean(currentRing.ReardEnable); //setReardEnable
            UserRingStationInfo[] ringStations =
                RingStationMgr.GetRingStationInfos(currentRing.UserID, currentRing.Rank);
            pkg.WriteInt(ringStations.Length);
            foreach (UserRingStationInfo ring in ringStations)
            {
                PlayerInfo PlayerCharacter = ring.Info;
                pkg.WriteInt(PlayerCharacter.ID); //_loc_2.ID = param1.readInt();
                pkg.WriteString(PlayerCharacter.UserName); //_loc_2.LoginName = param1.readUTF();
                pkg.WriteString(PlayerCharacter.NickName); //_loc_2.NickName = param1.readUTF();
                pkg.WriteByte(PlayerCharacter.typeVIP); //_loc_2.typeVIP = param1.readByte();
                pkg.WriteInt(PlayerCharacter.VIPLevel); //_loc_2.VIPLevel = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Grade); //_loc_2.Grade = param1.readInt();

                pkg.WriteBoolean(PlayerCharacter.Sex); //_loc_2.Sex = param1.readBoolean();
                pkg.WriteString(PlayerCharacter.Style); //_loc_2.Style = param1.readUTF();
                pkg.WriteString(PlayerCharacter.Colors); //_loc_2.Colors = param1.readUTF();
                pkg.WriteString(PlayerCharacter.Skin); //_loc_2.Skin = param1.readUTF();
                pkg.WriteString(PlayerCharacter.ConsortiaName); //_loc_2.ConsortiaName = param1.readUTF();
                pkg.WriteInt(PlayerCharacter.Hide); //_loc_2.Hide = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Offer); //_loc_2.Offer = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Win); //_loc_2.WinCount = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Total); //_loc_2.TotalCount = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Escape); //_loc_2.EscapeCount = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Repute); //_loc_2.Repute = param1.readInt();
                pkg.WriteInt(PlayerCharacter.Nimbus); //_loc_2.Nimbus = param1.readInt();
                pkg.WriteInt(PlayerCharacter.GP > Int32.MaxValue ? Int32.MaxValue : Convert.ToInt32(PlayerCharacter.GP)); //_loc_2.GP = param1.readInt();
                pkg.WriteInt(PlayerCharacter.FightPower); //_loc_2.FightPower = param1.readInt();
                pkg.WriteInt(PlayerCharacter.AchievementPoint); //_loc_2.AchievementPoint = param1.readInt();
                pkg.WriteInt(ring.Rank); //_loc_2.Rank = param1.readInt();      
                pkg.WriteBoolean(false); //player.isAttest = pkg.readBoolean();
                pkg.WriteInt(ring.WeaponID); //_loc_2.WeaponID = param1.readInt();
                pkg.WriteString(ring.signMsg); //_loc_2.signMsg = param1.readUTF();
            }

            Player.SendTCP(pkg);
            return true;
        }
    }
}