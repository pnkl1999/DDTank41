

using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class MountTalismansInfo
    {
        public int ID { get; set; }
        public string AmuletName { get; set; }
        public int BaseType1 { get; set; }
        public int BaseType1Value { get; set; }
        public int BaseType2 { get; set; }
        public int BaseType2Value { get; set; }
        public int Consume { get; set; }
        public string Desc { get; set; }
        public int ExtendType1 { get; set; }
        public int ExtendType1MaxValue { get; set; }
        public int ExtendType1MinValue { get; set; }
        public int ExtendType2 { get; set; }
        public int ExtendType2MaxValue { get; set; }
        public int ExtendType2MinValue { get; set; }
        public bool IsCanWash { get; set; }
        public string PicUrl { get; set; }
        public int Quality { get; set; }
        public string Remark { get; set; }
        public int Score { get; set; }
        public int ShatterNum { get; set; }
    }
}

