using System;

namespace SqlDataProvider.Data
{
    public class UserRingStationInfo : DataObject
    {
        private int _BaseDamage;

        private int _BaseEnergy;

        private int _BaseGuard;

        private int _buyCount;

        private int _ChallengeNum;

        private DateTime _ChallengeTime;

        private int _ID;

        private DateTime _LastDate;

        private bool _OnFight;

        private PlayerInfo _playerInfo;

        private int _Rank;

        private string _signMsg;

        private int _Total;

        private int _UserID;

        private int _WeaponID;

        private bool _reardEnable;

        public int BaseDamage
        {
			get
			{
				return _BaseDamage;
			}
			set
			{
				_BaseDamage = value;
				_isDirty = true;
			}
        }

        public int BaseEnergy
        {
			get
			{
				return _BaseEnergy;
			}
			set
			{
				_BaseEnergy = value;
				_isDirty = true;
			}
        }

        public int BaseGuard
        {
			get
			{
				return _BaseGuard;
			}
			set
			{
				_BaseGuard = value;
				_isDirty = true;
			}
        }

        public int buyCount
        {
			get
			{
				return _buyCount;
			}
			set
			{
				_buyCount = value;
				_isDirty = true;
			}
        }

        public int ChallengeNum
        {
			get
			{
				return _ChallengeNum;
			}
			set
			{
				_ChallengeNum = value;
				_isDirty = true;
			}
        }

        public DateTime ChallengeTime
        {
			get
			{
				return _ChallengeTime;
			}
			set
			{
				_ChallengeTime = value;
				_isDirty = true;
			}
        }

        public int ID
        {
			get
			{
				return _ID;
			}
			set
			{
				_ID = value;
				_isDirty = true;
			}
        }

        public PlayerInfo Info
        {
			get
			{
				return _playerInfo;
			}
			set
			{
				_playerInfo = value;
			}
        }

        public DateTime LastDate
        {
			get
			{
				return _LastDate;
			}
			set
			{
				_LastDate = value;
				_isDirty = true;
			}
        }

        public bool OnFight
        {
			get
			{
				return _OnFight;
			}
			set
			{
				_OnFight = value;
			}
        }

        public int Rank
        {
			get
			{
				return _Rank;
			}
			set
			{
				_Rank = value;
				_isDirty = true;
			}
        }

        public string signMsg
        {
			get
			{
				return _signMsg;
			}
			set
			{
				_signMsg = value;
				_isDirty = true;
			}
        }

        public int Total
        {
			get
			{
				return _Total;
			}
			set
			{
				_Total = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return _UserID;
			}
			set
			{
				_UserID = value;
				_isDirty = true;
			}
        }

        public int WeaponID
        {
			get
			{
				return _WeaponID;
			}
			set
			{
				_WeaponID = value;
				_isDirty = true;
			}
        }

        public bool ReardEnable
        {
			get
			{
				return _reardEnable;
			}
			set
			{
				_reardEnable = value;
				_isDirty = true;
			}
        }

        public bool CanChallenge()
        {
			return (600000 - (int)(DateTime.Now - _ChallengeTime).TotalMilliseconds) / 10 / 60 / 1000 <= 0;
        }
    }
}
