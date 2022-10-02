// Decompiled with JetBrains decompiler
// Type: Tank.Data.DDTService.ValidateLoginAndGetIDResponse
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using System.CodeDom.Compiler;
using System.Diagnostics;
using System.ServiceModel;

namespace Tank.Data.DDTService
{
  [DebuggerStepThrough]
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  [MessageContract(IsWrapped = true, WrapperName = "ValidateLoginAndGetIDResponse", WrapperNamespace = "http://tempuri.org/")]
  public class ValidateLoginAndGetIDResponse
  {
    [MessageBodyMember(Namespace = "http://tempuri.org/", Order = 0)]
    public bool ValidateLoginAndGetIDResult;
    [MessageBodyMember(Namespace = "http://tempuri.org/", Order = 1)]
    public int userID;
    [MessageBodyMember(Namespace = "http://tempuri.org/", Order = 2)]
    public bool isFirst;

    public ValidateLoginAndGetIDResponse()
    {
    }

    public ValidateLoginAndGetIDResponse(
      bool ValidateLoginAndGetIDResult,
      int userID,
      bool isFirst)
    {
      this.ValidateLoginAndGetIDResult = ValidateLoginAndGetIDResult;
      this.userID = userID;
      this.isFirst = isFirst;
    }
  }
}
