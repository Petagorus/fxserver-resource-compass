Citizen.CreateThread( function()
	if Config.compass.position.centered then
		Config.compass.position.x = Config.compass.position.x - Config.compass.width / 2
	end

	while Config.compass.show do
		Wait( 0 )

		local pxDegree = Config.compass.width / Config.compass.fov
		local playerHeadingDegrees = 0

		if Config.compass.followGameplayCam then
			-- Converts [-180, 180] to [0, 360] where E = 90 and W = 270
			local camRot = Citizen.InvokeNative( 0x837765A25378F0BB, 0, Citizen.ResultAsVector() )
			playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
		else
			-- Converts E = 270 to E = 90
			playerHeadingDegrees = 360.0 - GetEntityHeading( GetPlayerPed( -1 ) )
		end

		local tickDegree = playerHeadingDegrees - Config.compass.fov / 2
		local tickDegreeRemainder = Config.compass.ticksBetweenCardinals - (tickDegree % Config.compass.ticksBetweenCardinals)
		local tickPosition = Config.compass.position.x + tickDegreeRemainder * pxDegree

		tickDegree = tickDegree + tickDegreeRemainder

		while tickPosition < Config.compass.position.x + Config.compass.width do
			if (tickDegree % 90.0) == 0 then
				-- Draw cardinal
				if Config.compass.cardinal.tickShow then
					DrawRect( tickPosition, Config.compass.position.y, Config.compass.cardinal.tickSize.w, Config.compass.cardinal.tickSize.h, Config.compass.cardinal.tickColour.r, Config.compass.cardinal.tickColour.g, Config.compass.cardinal.tickColour.b, Config.compass.cardinal.tickColour.a )
				end

				drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, Config.compass.position.y + Config.compass.cardinal.textOffset, {
					size = Config.compass.cardinal.textSize,
					colour = Config.compass.cardinal.textColour,
					outline = true,
					centered = true
				})
			elseif (tickDegree % 45.0) == 0 and Config.compass.intercardinal.show then
				-- Draw intercardinal
				if Config.compass.intercardinal.tickShow then
					DrawRect( tickPosition, Config.compass.position.y, Config.compass.intercardinal.tickSize.w, Config.compass.intercardinal.tickSize.h, Config.compass.intercardinal.tickColour.r, Config.compass.intercardinal.tickColour.g, Config.compass.intercardinal.tickColour.b, Config.compass.intercardinal.tickColour.a )
				end

				if Config.compass.intercardinal.textShow then
					drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, Config.compass.position.y + Config.compass.intercardinal.textOffset, {
						size = Config.compass.intercardinal.textSize,
						colour = Config.compass.intercardinal.textColour,
						outline = true,
						centered = true
					})
				end
			else
				-- Draw tick
				DrawRect( tickPosition, Config.compass.position.y, Config.compass.tickSize.w, Config.compass.tickSize.h, Config.compass.tickColour.r, Config.compass.tickColour.g, Config.compass.tickColour.b, Config.compass.tickColour.a )
			end

			-- Advance to the next tick
			tickDegree = tickDegree + Config.compass.ticksBetweenCardinals
			tickPosition = tickPosition + pxDegree * Config.compass.ticksBetweenCardinals
		end

		if Config.compass.needle.show then
			drawText(
				tostring(round(playerHeadingDegrees)),
				Config.compass.position.x + Config.compass.width / 2,
				Config.compass.position.y - Config.compass.needle.textOffset,
				{
					size = Config.compass.needle.textSize,
					colour = Config.compass.needle.textColour,
					outline = true,
					centered = true
				}
			)
			DrawRect(
				Config.compass.position.x + Config.compass.width / 2,
				Config.compass.position.y,
				Config.compass.needle.needleSize.w,
				Config.compass.needle.needleSize.h,
				Config.compass.needle.needleColour.r,
				Config.compass.needle.needleColour.g,
				Config.compass.needle.needleColour.b,
				Config.compass.needle.needleColour.a
			)
		end

	end
end)
