package par.renderer
{
	import par.particals.Particle;
	
	public interface IParticleRenderer
	{
		
		
		function renderParticles(param1:Vector.<Particle>) : void;
		
		function addParticle(param1:Particle) : void;
		
		function removeParticle(param1:Particle) : void;
		
		function reset() : void;
		
		function dispose() : void;
	}
}
