using System;

namespace SqlDataProvider.Data
{

    public class PyramidConfigInfo
    {
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
            }
        }

        private bool _isOpen;
        public bool isOpen
        {
            get
            {
                return _isOpen;
            }
            set
            {
                _isOpen = value;
            }
        }

        private bool _isScoreExchange;
        public bool isScoreExchange
        {
            get
            {
                return _isScoreExchange;
            }
            set
            {
                _isScoreExchange = value;
            }
        }

        private DateTime _beginTime;
        public DateTime beginTime
        {
            get
            {
                return _beginTime;
            }
            set
            {
                _beginTime = value;
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
            }
        }

        private int _freeCount;
        public int freeCount
        {
            get
            {
                return _freeCount;
            }
            set
            {
                _freeCount = value;
            }
        }
        private int _turnCardPrice;
        public int turnCardPrice
        {
            get
            {
                return _turnCardPrice;
            }
            set
            {
                _turnCardPrice = value;
            }
        }

        private int[] _revivePrice;
        public int[] revivePrice
        {
            get
            {
                return _revivePrice;
            }
            set
            {
                _revivePrice = value;
            }
        }
    }
}

