using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UsersMagicHouseInfo : DataObject
    {
        private int _iD;
        public int ID
        {
            get { return _iD; }
            set { _iD = value; _isDirty = true; }
        }
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private bool _isOpen;
        public bool isOpen
        {
            get { return _isOpen; }
            set { _isOpen = value; _isDirty = true; }
        }
        private bool _isMagicRoomShow;
        public bool isMagicRoomShow
        {
            get { return _isMagicRoomShow; }
            set { _isMagicRoomShow = value; _isDirty = true; }
        }
        private int _magicJuniorLv;
        public int magicJuniorLv
        {
            get { return _magicJuniorLv; }
            set { _magicJuniorLv = value; _isDirty = true; }
        }
        private int _magicJuniorExp;
        public int magicJuniorExp
        {
            get { return _magicJuniorExp; }
            set { _magicJuniorExp = value; _isDirty = true; }
        }
        private int _magicMidLv;
        public int magicMidLv
        {
            get { return _magicMidLv; }
            set { _magicMidLv = value; _isDirty = true; }
        }
        private int _magicMidExp;
        public int magicMidExp
        {
            get { return _magicMidExp; }
            set { _magicMidExp = value; _isDirty = true; }
        }
        private int _magicSeniorLv;
        public int magicSeniorLv
        {
            get { return _magicSeniorLv; }
            set { _magicSeniorLv = value; _isDirty = true; }
        }
        private int _magicSeniorExp;
        public int magicSeniorExp
        {
            get { return _magicSeniorExp; }
            set { _magicSeniorExp = value; _isDirty = true; }
        }
        private int _freeGetCount;
        public int freeGetCount
        {
            get { return _freeGetCount; }
            set { _freeGetCount = value; _isDirty = true; }
        }
        private DateTime _freeGetTime;
        public DateTime freeGetTime
        {
            get { return _freeGetTime; }
            set { _freeGetTime = value; _isDirty = true; }
        }
        private int _chargeGetCount;
        public int chargeGetCount
        {
            get { return _chargeGetCount; }
            set { _chargeGetCount = value; _isDirty = true; }
        }
        private DateTime _chargeGetTime;
        public DateTime chargeGetTime
        {
            get { return _chargeGetTime; }
            set { _chargeGetTime = value; _isDirty = true; }
        }
        private int _depotCount;
        public int depotCount
        {
            get { return _depotCount; }
            set { _depotCount = value; _isDirty = true; }
        }

        private int _essence;
        public int essence
        {
            get { return _essence; }
            set { _essence = value; _isDirty = true; }
        }
        private string _activityWeapons;
        public string activityWeapons
        {
            get { return _activityWeapons; }
            set { _activityWeapons = value; _isDirty = true; }
        }
    }
}
