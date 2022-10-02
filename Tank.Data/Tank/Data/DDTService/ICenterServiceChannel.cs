// Decompiled with JetBrains decompiler
// Type: Tank.Data.DDTService.ICenterServiceChannel
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using System;
using System.CodeDom.Compiler;
using System.ServiceModel;
using System.ServiceModel.Channels;

namespace Tank.Data.DDTService
{
  [GeneratedCode("System.ServiceModel", "4.0.0.0")]
  public interface ICenterServiceChannel : 
    ICenterService,
    IClientChannel,
    IContextChannel,
    IChannel,
    ICommunicationObject,
    IExtensibleObject<IContextChannel>,
    IDisposable
  {
  }
}
