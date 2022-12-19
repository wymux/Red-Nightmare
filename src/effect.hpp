#ifndef REDNIGHTMARE_EFFECT_HPP
#define REDNIGHTMARE_EFFECT_HPP
#include "tz/gl/resource.hpp"
#include "tz/gl/component.hpp"
#include "tz/gl/renderer.hpp"

namespace game
{
	enum class EffectID
	{
		None,
		Rain,
		Count
	};

	using EffectIDs = tz::EnumField<EffectID>;

	class EffectManager
	{
	public:
		EffectManager();
		~EffectManager();
		EffectManager(const EffectManager& copy) = delete;
		EffectManager(EffectManager&& move) = delete;

		void update(EffectIDs ids = {});
		tz::gl::ImageComponent* get_effect_component(EffectID id);
	private:
		tz::gl::RendererHandle make_rain_effect();
		std::vector<tz::gl::RendererHandle> effect_renderers = {};
		tz::gl::ResourceHandle rain_image = hdk::nullhand;
	};

	namespace effects_impl
	{
		void initialise();
		void terminate();
	}

	EffectManager& effects();
}

#endif // REDNIGHTMARE_EFFECT_HPP
