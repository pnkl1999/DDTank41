using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.Serialization;

namespace Bussiness.CenterService
{
    [Serializable]
	[DebuggerStepThrough]
	[GeneratedCode("System.Runtime.Serialization", "4.0.0.0")]
	[DataContract(Name = "ServerData", Namespace = "http://schemas.datacontract.org/2004/07/Center.Server")]
	public class ServerData : IExtensibleDataObject, INotifyPropertyChanged
    {
        [NonSerialized]
		private ExtensionDataObject extensionDataField;

        [OptionalField]
		private int IdField;

        [OptionalField]
		private string IpField;

        [OptionalField]
		private int LowestLevelField;

        [OptionalField]
		private int MustLevelField;

        [OptionalField]
		private string NameField;

        [OptionalField]
		private int OnlineField;

        [OptionalField]
		private int PortField;

        [OptionalField]
		private int StateField;

        [Browsable(false)]
		public ExtensionDataObject ExtensionData
        {
			get
			{
				return extensionDataField;
			}
			set
			{
				extensionDataField = value;
			}
        }

        [DataMember]
		public int Id
        {
			get
			{
				return IdField;
			}
			set
			{
				if (!IdField.Equals(value))
				{
					IdField = value;
					RaisePropertyChanged("Id");
				}
			}
        }

        [DataMember]
		public string Ip
        {
			get
			{
				return IpField;
			}
			set
			{
				if ((object)IpField != value)
				{
					IpField = value;
					RaisePropertyChanged("Ip");
				}
			}
        }

        [DataMember]
		public int LowestLevel
        {
			get
			{
				return LowestLevelField;
			}
			set
			{
				if (!LowestLevelField.Equals(value))
				{
					LowestLevelField = value;
					RaisePropertyChanged("LowestLevel");
				}
			}
        }

        [DataMember]
		public int MustLevel
        {
			get
			{
				return MustLevelField;
			}
			set
			{
				if (!MustLevelField.Equals(value))
				{
					MustLevelField = value;
					RaisePropertyChanged("MustLevel");
				}
			}
        }

        [DataMember]
		public string Name
        {
			get
			{
				return NameField;
			}
			set
			{
				if ((object)NameField != value)
				{
					NameField = value;
					RaisePropertyChanged("Name");
				}
			}
        }

        [DataMember]
		public int Online
        {
			get
			{
				return OnlineField;
			}
			set
			{
				if (!OnlineField.Equals(value))
				{
					OnlineField = value;
					RaisePropertyChanged("Online");
				}
			}
        }

        [DataMember]
		public int Port
        {
			get
			{
				return PortField;
			}
			set
			{
				if (!PortField.Equals(value))
				{
					PortField = value;
					RaisePropertyChanged("Port");
				}
			}
        }

        [DataMember]
		public int State
        {
			get
			{
				return StateField;
			}
			set
			{
				if (!StateField.Equals(value))
				{
					StateField = value;
					RaisePropertyChanged("State");
				}
			}
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
			this.PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
