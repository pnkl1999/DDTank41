using Bussiness.WebLogin;
using System;

namespace Bussiness.Interface
{
    public class SRInterface : BaseInterface
    {
        public override bool GetUserSex(string name)
        {
			try
			{
				return new PassPortSoapClient().Get_UserSex(string.Empty, name).Value;
			}
			catch (Exception exception)
			{
				BaseInterface.log.Error("获取性别失败", exception);
				return true;
			}
        }
    }
}
