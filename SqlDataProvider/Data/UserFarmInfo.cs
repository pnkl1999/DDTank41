using System;

namespace SqlDataProvider.Data
{
    public class UserFarmInfo : DataObject
    {
        private UserFieldInfo _field;

        private int _ID;

        private int _farmID;

        private string _payFieldMoney;

        private string _payAutoMoney;

        private DateTime _autoPayTime;

        private int _autoValidDate;

        private int _vipLimitLevel;

        private string _farmerName;

        private int _gainFieldId;

        private int _matureId;

        private int _killCropId;

        private int _isAutoId;

        private bool _isFarmHelper;

        private int _buyExpRemainNum;

        private bool _isArrange;

        private int _treeLevel;

        private int _treeExp;

        private int _loveScore;

        private int _monsterExp;

        private int _poultryState;

        private DateTime _countDownTime;

        private int _treeCostExp;

        public UserFieldInfo Field
        {
			get
			{
				return _field;
			}
			set
			{
				_field = value;
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

        public int FarmID
        {
			get
			{
				return _farmID;
			}
			set
			{
				_farmID = value;
				_isDirty = true;
			}
        }

        public string PayFieldMoney
        {
			get
			{
				return _payFieldMoney;
			}
			set
			{
				_payFieldMoney = value;
				_isDirty = true;
			}
        }

        public string PayAutoMoney
        {
			get
			{
				return _payAutoMoney;
			}
			set
			{
				_payAutoMoney = value;
				_isDirty = true;
			}
        }

        public DateTime AutoPayTime
        {
			get
			{
				return _autoPayTime;
			}
			set
			{
				_autoPayTime = value;
				_isDirty = true;
			}
        }

        public int AutoValidDate
        {
			get
			{
				return _autoValidDate;
			}
			set
			{
				_autoValidDate = value;
				_isDirty = true;
			}
        }

        public int VipLimitLevel
        {
			get
			{
				return _vipLimitLevel;
			}
			set
			{
				_vipLimitLevel = value;
				_isDirty = true;
			}
        }

        public string FarmerName
        {
			get
			{
				return _farmerName;
			}
			set
			{
				_farmerName = value;
				_isDirty = true;
			}
        }

        public int GainFieldId
        {
			get
			{
				return _gainFieldId;
			}
			set
			{
				_gainFieldId = value;
				_isDirty = true;
			}
        }

        public int MatureId
        {
			get
			{
				return _matureId;
			}
			set
			{
				_matureId = value;
				_isDirty = true;
			}
        }

        public int KillCropId
        {
			get
			{
				return _killCropId;
			}
			set
			{
				_killCropId = value;
				_isDirty = true;
			}
        }

        public int isAutoId
        {
			get
			{
				return _isAutoId;
			}
			set
			{
				_isAutoId = value;
				_isDirty = true;
			}
        }

        public bool isFarmHelper
        {
			get
			{
				return _isFarmHelper;
			}
			set
			{
				_isFarmHelper = value;
				_isDirty = true;
			}
        }

        public int buyExpRemainNum
        {
			get
			{
				return _buyExpRemainNum;
			}
			set
			{
				_buyExpRemainNum = value;
				_isDirty = true;
			}
        }

        public bool isArrange
        {
			get
			{
				return _isArrange;
			}
			set
			{
				_isArrange = value;
				_isDirty = true;
			}
        }

        public int TreeLevel
        {
			get
			{
				return _treeLevel;
			}
			set
			{
				_treeLevel = value;
				_isDirty = true;
			}
        }

        public int TreeExp
        {
			get
			{
				return _treeExp;
			}
			set
			{
				_treeExp = value;
				_isDirty = true;
			}
        }

        public int LoveScore
        {
			get
			{
				return _loveScore;
			}
			set
			{
				_loveScore = value;
				_isDirty = true;
			}
        }

        public int MonsterExp
        {
			get
			{
				return _monsterExp;
			}
			set
			{
				_monsterExp = value;
				_isDirty = true;
			}
        }

        public int PoultryState
        {
			get
			{
				return _poultryState;
			}
			set
			{
				_poultryState = value;
				_isDirty = true;
			}
        }

        public DateTime CountDownTime
        {
			get
			{
				return _countDownTime;
			}
			set
			{
				_countDownTime = value;
				_isDirty = true;
			}
        }

        public int TreeCostExp
        {
			get
			{
				return _treeCostExp;
			}
			set
			{
				_treeCostExp = value;
				_isDirty = true;
			}
        }

        public bool isFeed()
        {
			int timeLeft = 3600000 - (int)(DateTime.Now - _countDownTime).TotalMilliseconds;
			timeLeft = timeLeft / 60 / 60 / 1000;
			return timeLeft <= 0;
        }
    }
}
