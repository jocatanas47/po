function Y = isecanje(X)
    % isecanje oblika

    % binarizacija slike
    M = max(X);
    T = 0.8;
    Y = X;
    Y(X > T*M) = 255;
    Y(X <= T*M) = 0;

    % isecanje piksela
    % secemo crno sa strana, krecemo od 10 piksela
    [M, N] = size(X);
    levo = 10;
    while ((sum(Y(:, levo))/255 < 0.8*M) && (levo < N))
        levo = levo + 1;
    end
    desno = N - 10;
    while ((sum(Y(:, desno))/255 < 0.8*M) && (desno > 1))
        desno = desno - 1;
    end
    gore = 10;
    while ((sum(Y(gore, :))/255 < 0.8*N) && (gore < M))
        gore = gore + 1;
    end
    dole = M - 10;
    while ((sum(Y(dole, :))/255 < 0.8*N) && (dole > 1))
        dole = dole - 1;
    end

    Y = Y(gore:dole, levo:desno);

    % medijan filter - uklanja same crne tacke
    Y = medfilt2(Y);

    % isecanje belog okvira
    P = 0.99; % prag
    [M, N] = size(Y);

    levo = 1;
    while ((levo < N) && (sum(Y(:, levo))/255 > P*M))
        levo = levo + 1;
    end
    desno = N - 10;
    while ((desno > 1) && (sum(Y(:, desno))/255 > P*M))
        desno = desno - 1;
    end
    gore = 10;
    while ((gore < M) && (sum(Y(gore, :))/255 > P*N))
        gore = gore + 1;
    end
    dole = M - 10;
    while ((dole > 1) && (sum(Y(dole, :))/255 > P*N))
        dole = dole - 1;
    end
    Y = Y(gore:dole, levo:desno);

end