package ddt.data.goods
{
   import ddt.manager.LanguageMgr;
   
   public class QualityType
   {
      
      public static const QUALITY_STRING:Array = ["",LanguageMgr.GetTranslation("tank.data.QualityType.cucao"),LanguageMgr.GetTranslation("tank.data.QualityType.putong"),LanguageMgr.GetTranslation("tank.data.QualityType.youxiu"),LanguageMgr.GetTranslation("tank.data.QualityType.jingliang"),LanguageMgr.GetTranslation("tank.data.QualityType.zhuoyue"),LanguageMgr.GetTranslation("tank.data.QualityType.chuanshuo"),LanguageMgr.GetTranslation("tank.data.QualityType.shenqi")];
      
      public static const QUALITY_COLOR:Array = [0,14803425,2031360,28893,10696174,16744448,16711833,15060096];
       
      
      public function QualityType()
      {
         super();
      }
   }
}
