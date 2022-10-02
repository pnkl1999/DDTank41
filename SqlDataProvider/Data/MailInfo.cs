using System;

namespace SqlDataProvider.Data
{
    public class MailInfo
    {
        public string Annex1 { get; set; }

        public string Annex1Name { get; set; }

        public string Annex2 { get; set; }

        public string Annex2Name { get; set; }

        public string Annex3 { get; set; }

        public string Annex3Name { get; set; }

        public string Annex4 { get; set; }

        public string Annex4Name { get; set; }

        public string Annex5 { get; set; }

        public string Annex5Name { get; set; }

        public string AnnexRemark { get; set; }

        public string Content { get; set; }

        public int Gold { get; set; }

        public int GiftToken { get; set; }

        public int ID { get; set; }

        public bool IsExist { get; set; }

        public bool IsRead { get; set; }

        public int Money { get; set; }

        public string Receiver { get; set; }

        public int ReceiverID { get; set; }

        public string Sender { get; set; }

        public int SenderID { get; set; }

        public DateTime SendTime { get; set; }

        public string Title { get; set; }

        public int Type { get; set; }

        public int ValidDate { get; set; }

        public void Revert()
        {
			ID = 0;
			SenderID = 0;
			Sender = "";
			ReceiverID = 0;
			Receiver = "";
			Title = "";
			Content = "";
			Annex1 = "";
			Annex2 = "";
			Gold = 0;
			Money = 0;
			GiftToken = 0;
			IsExist = false;
			Type = 0;
			ValidDate = 0;
			IsRead = false;
			SendTime = DateTime.Now;
			Annex1Name = "";
			Annex2Name = "";
			Annex3 = "";
			Annex4 = "";
			Annex5 = "";
			Annex3Name = "";
			Annex4Name = "";
			Annex5Name = "";
			AnnexRemark = "";
        }
    }
}
