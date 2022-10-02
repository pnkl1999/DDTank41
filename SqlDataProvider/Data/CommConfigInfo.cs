using System;

namespace SqlDataProvider.Data
{
    public class CommConfigInfo
    {
        private int _ID;

        private DateTime _ParaDate1;

        private DateTime _ParaDate2;

        private DateTime _ParaDate3;

        private int _ParaNumber1;

        private int _ParaNumber2;

        private int _ParaNumber3;

        private string _ParaString1;

        private string _ParaString2;

        private string _ParaString3;

        public int ID
        {
			get
			{
				return _ID;
			}
			set
			{
				_ID = value;
			}
        }

        public DateTime ParaDate1
        {
			get
			{
				return _ParaDate1;
			}
			set
			{
				_ParaDate1 = value;
			}
        }

        public DateTime ParaDate2
        {
			get
			{
				return _ParaDate2;
			}
			set
			{
				_ParaDate2 = value;
			}
        }

        public DateTime ParaDate3
        {
			get
			{
				return _ParaDate3;
			}
			set
			{
				_ParaDate3 = value;
			}
        }

        public int ParaNumber1
        {
			get
			{
				return _ParaNumber1;
			}
			set
			{
				_ParaNumber1 = value;
			}
        }

        public int ParaNumber2
        {
			get
			{
				return _ParaNumber2;
			}
			set
			{
				_ParaNumber2 = value;
			}
        }

        public int ParaNumber3
        {
			get
			{
				return _ParaNumber3;
			}
			set
			{
				_ParaNumber3 = value;
			}
        }

        public string ParaString1
        {
			get
			{
				return _ParaString1;
			}
			set
			{
				_ParaString1 = value;
			}
        }

        public string ParaString2
        {
			get
			{
				return _ParaString2;
			}
			set
			{
				_ParaString2 = value;
			}
        }

        public string ParaString3
        {
			get
			{
				return _ParaString3;
			}
			set
			{
				_ParaString3 = value;
			}
        }

        public CommConfigInfo()
        {
        }

        public CommConfigInfo(int ID, string ParaString1, string ParaString2, string ParaString3, DateTime ParaDate1, DateTime ParaDate2, DateTime ParaDate3, int ParaNumber1, int ParaNumber2, int ParaNumber3)
        {
			_ID = ID;
			_ParaString1 = ParaString1;
			_ParaString2 = ParaString2;
			_ParaString3 = ParaString3;
			_ParaDate1 = ParaDate1;
			_ParaDate2 = ParaDate2;
			_ParaDate3 = ParaDate3;
			_ParaNumber1 = ParaNumber1;
			_ParaNumber2 = ParaNumber2;
			_ParaNumber3 = ParaNumber3;
        }
    }
}
