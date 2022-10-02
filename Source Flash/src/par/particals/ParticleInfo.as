package par.particals
{
   import par.creators.DefaultCreator;
   import par.creators.IParticalCreator;
   import par.lifeeasing.AbstractLifeEasing;
   
   public class ParticleInfo
   {
      
      public static var DEFAULT_CREATOR:IParticalCreator = new DefaultCreator();
      
      public static var DEFAULT_LIFEEASING:AbstractLifeEasing = new AbstractLifeEasing();
       
      
      public var name:String = "particle";
      
      public var beginTime:Number = 0;
      
      public var endTime:Number = 1000;
      
      public var lifeOrient:Number = 1;
      
      public var lifeSize:Number = 0;
      
      public var countOrient:Number = 1;
      
      public var countSize:Number = 0;
      
      public var sizeOrient:Number = 1;
      
      public var sizeSize:Number = 0;
      
      public var vOrient:Number = 0;
      
      public var vSize:Number = 0;
      
      public var weightOrient:Number = 0;
      
      public var weightSize:Number = 0;
      
      public var spinOrient:Number = 0;
      
      public var spinSize:Number = 0;
      
      public var motionVOrient:Number = 0;
      
      public var motionVSize:Number = 0;
      
      public var alphaOrient:uint = 1;
      
      public var colorOrient:uint = 0;
      
      public var keepColor:Boolean = false;
      
      public var keepOldFirst:Boolean = false;
      
      public var blendMode:String = "add";
      
      public var displayCreator:uint = 0;
      
      public var lifeEasing:AbstractLifeEasing;
      
      public var rotation:Number = 0;
      
      public function ParticleInfo()
      {
         this.lifeEasing = DEFAULT_LIFEEASING;
         super();
      }
   }
}
