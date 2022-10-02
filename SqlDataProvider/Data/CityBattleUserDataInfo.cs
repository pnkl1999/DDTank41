using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class CityBattleUserDataInfo : DataObject
    {
        private string _ID;
        public string ID
        {
            get { return _ID; }
            set { _ID = value; _isDirty = true; }
        }

        private string _UserData;
        public string UserData
        {
            get { return _UserData; }
            set { _UserData = value; _isDirty = true; }
        }

        private string _UserExchangeData;
        public string UserExchangeData
        {
            get { return _UserExchangeData; }
            set { _UserExchangeData = value; _isDirty = true; }
        }

        private string _GameData;
        public string GameData
        {
            get { return _GameData; }
            set { _GameData = value; _isDirty = true; }
        }
    }
}
