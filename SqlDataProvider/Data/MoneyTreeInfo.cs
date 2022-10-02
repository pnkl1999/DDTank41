using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class MoneyTreeInfo
    {
        private int _itemId;
        public int ItemID
        {
            get { return _itemId; }
            set { _itemId = value; }
        }
        private DateTime _timeGrown;
        public DateTime timeGrown
        {
            get { return _timeGrown; }
            set { _timeGrown = value;}
        }
        private int _priceSpeedUp;
        public int priceSpeedUp
        {
            get { return _priceSpeedUp; }
            set { _priceSpeedUp = value; }
        }
        private int _positon;
        public int positon
        {
            get { return _positon; }
            set { _positon = value; }
        }
        private int _pickDaily;
        public int PickDaily
        {
            get { return _pickDaily; }
            set { _pickDaily = value; }
        }
        public bool CanDrop()
        {
            int timeLeft = DateTime.Compare(_timeGrown, DateTime.Now);
            //Console.WriteLine("timeLeft {0}", timeLeft);
            return timeLeft > 0;
        }
    }
}
