// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.TableDesignInfo
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

namespace SqlDataProvider.Data
{
  public class TableDesignInfo
  {
    public int ID { get; set; }

    public int TableID { get; set; }

    public string Name { get; set; }

    public string Type { get; set; }

    public bool IdEntity { get; set; }

    public bool IsPrimary { get; set; }

    public bool IsNotNull { get; set; }

    public bool IsShowHide { get; set; }

    public bool IsGetMax { get; set; }

    public string TableGetMax { get; set; }

    public string ColGetMax { get; set; }

    public bool HasConditon { get; set; }

    public string Conditon { get; set; }

    public bool IntParse { get; set; }

    public string FileName { get; set; }
  }
}
