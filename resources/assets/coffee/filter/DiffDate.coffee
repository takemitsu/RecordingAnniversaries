
mainControllers.filter 'DiffDate', ->
  return (input) ->

    # 前置き

    if not input
        return ''

    if input.length isnt 10
        return ''

    dates = input.split("-");
    if dates.length isnt 3
        return ''

    date = parseInt(dates.join(""))
    if not date
        return ''

    if dates[0] > 2099
        return ''
    if dates[1] > 12 || dates[1] is "00"
        return ''
    if dates[2] > 31 || dates[2] is "00"
        return

    # 本処理

    date = new Date(dates[0], dates[1] - 1, dates[2])
    now = new Date()
    now = new Date(now.getFullYear(), now.getMonth(), now.getDate())

    diff_date = new Date(now.getFullYear(), date.getMonth(), date.getDate())
    if now > diff_date
        diff_date = new Date(now.getFullYear() + 1, date.getMonth(), date.getDate())

    diff = diff_date - now;
    diffDay = diff / 86400000
    return diffDay


mainControllers.filter 'Nenrei', ->
  return (input, append_year, unit, month_flag, unit_month) ->

    if not input
        return ''

    if input.length isnt 10
        return ''

    dates = input.split("-");
    if dates.length isnt 3
        return ''

    date = parseInt(dates.join(""))
    if not date
        return ''

    if dates[0] > 2099
        return ''
    if dates[1] > 12 || dates[1] is "00"
        return ''
    if dates[2] > 31 || dates[2] is "00"
        return

    # ----------------------------------
    # console.log append_year
    # now = new Date()
    # now = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    # if append_year
    #     return now.getFullYear() - dates[0] + append_year
    # return now.getFullYear() - dates[0]
    # diff_date = new Date(dates[0], dates[1] - 1, dates[2])
    # diff_date = new Date(now.getFullYear(), date.getMonth(), date.getDate())
    # if now > diff_date
    #     diff_date = new Date(now.getFullYear() + 1, date.getMonth(), date.getDate())

    today = new Date();
    today = today.getFullYear() * 10000 + today.getMonth() * 100 + 100 + today.getDate()
    birthday = parseInt(dates.join(""));
    # console.log birthday
    # birthday = parseInt(input.replace(/-/g,’’));
    diff = Math.floor((today - birthday) / 10000);

    if append_year
        diff += 1
    if diff < 0
        return ''
    if unit
        diff += " " + unit
    # console.log month_flag
    # if month_flag
    #     today = new Date()
    #     today_m = today.getMonth() + 1
    #     today_d = today.getDate()
    #     if today_m < dates[1]
    #         today_m += 12
    #     if today_m == dates[1] && today_d < date[2]
    #         today_m += 12
    #     if today_d >= dates[2]
    #         today_m += 1
    #     age_m = today_m - dates[1]
    #     diff += " " + age_m

    #     if unit_month
    #         diff += " " + unit_month

    return diff
