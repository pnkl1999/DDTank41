using System;
using System.Collections.Generic;
using System.Linq;

namespace SqlDataProvider.Data
{

    public class UserAvatarColectionInfo : DataObject
    {
        private int _ID;
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

        private int _userID;
        public int UserID
        {
            get
            {
                return _userID;
            }
            set
            {
                _userID = value;
                _isDirty = true;
            }
        } 

        private DateTime _endTime;
        public DateTime endTime
        {
            get
            {
                return _endTime;
            }
            set
            {
                _endTime = value;
                _isDirty = true;
            }
        }
        public bool isValidate
        {
            get
            {
                return _endTime.Date >= DateTime.Now.Date;
            }
        }
        private int _dataId;
        public int dataId
        {
            get
            {
                return _dataId;
            }
            set
            {
                _dataId = value;
                _isDirty = true;
            }
        }

        private int _activeCount;
        public int ActiveCount
        {
            get
            {
                return _activeCount;
            }
            set
            {
                _activeCount = value;
                _isDirty = true;
            }
        }

        private int _sex;
        public int Sex
        {
            get
            {
                return _sex;
            }
            set
            {
                _sex = value;
                _isDirty = true;
            }
        }

        private string _activeDress;
        public string ActiveDress
        {
            get { return ConvertArray(); }
            set { _activeDress = value; _isDirty = true; }
        }

        public string[] CurrentGroup
        {
            get
            {
                if (string.IsNullOrEmpty(_activeDress))
                    return new string[0];

                return _activeDress.Split(',');
            }
        }

        public string ConvertArray()
        {
            if (string.IsNullOrEmpty(_activeDress))
            {
                return "";
            }
            string arrGroup = CurrentGroup.Aggregate("", (current, id) => current + ("," + id));
            return arrGroup.Substring(1);
        }
       
        public bool HaftActive()
        {
            return CurrentGroup.Length >= ActiveCount / 2;
        }

        public bool FullActive()
        {
            return CurrentGroup.Length >= ActiveCount;
        }
    }
}

