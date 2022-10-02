package lightRoad.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class LightCartoonInfo
   {
       
      
      private var _MC:MovieClip;
      
      private var _point:Point;
      
      private var _type:String = "";
      
      public function LightCartoonInfo(param1:String)
      {
         super();
         this._type = param1;
         switch(this._type)
         {
            case "5":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.1234light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos5");
               break;
            case "6":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.1234light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos6");
               break;
            case "8":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.56light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos8");
               break;
            case "11":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.1234light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos11");
               break;
            case "12":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.1234light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos12");
               break;
            case "14":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.1234light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos14");
               break;
            case "16":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.1234light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos16");
               break;
            case "17":
               this._MC = ComponentFactory.Instance.creat("asset.lightroad.swf.17light.mc");
               this._point = PositionUtils.creatPoint("light.getCartoonPos17");
         }
         this._MC.x = this._point.x;
         this._MC.y = this._point.y;
      }
      
      public function get MC() : MovieClip
      {
         return this._MC;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function dispose() : void
      {
         if(this._MC)
         {
            ObjectUtils.disposeObject(this._MC);
            this._MC = null;
         }
      }
   }
}
