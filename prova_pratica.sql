create table investidores(
	id serial primary key,
	nome varchar(100) not null,
	cpf varchar(11) unique not null,
	nivel_experiencia int default 0 check(nivel_experiencia >= 0)
);
create table carteiras(
	id serial primary key,
	investidor_id int references investidores(id),
	endereco_wallet varchar(100) unique not null,
	rede_blockchain varchar(100) not null,
	saldo_usd decimal(10,2) not null check(saldo_usd > 0),
	status varchar(100) default 'Ativa' check(status in('Ativa', 'Em Analise', 'Bloqueada'))
);
create table corretoras(
	id serial primary key,
	nome_exchange varchar(100) not null,
	cnpj varchar(14) unique not null,
	email_suporte varchar(100) unique not null
);
create table criptomoedas(
	id serial primary key,
	corretora_id int references corretoras(id),
	nome_moeda varchar(100) not null,
	preco_unitario_usd decimal(10,2) not null check(preco_unitario_usd > 0),
	categoria varchar(100) default 'Layer1' check(categoria in('Layer1', 'DeFi', 'Memecoin', 'Stablecoin'))
);
create table transacoes_cripto(
	id serial primary key,
	carteira_id int references carteiras(id),
	criptomoeda_id int references criptomoedas(id),
	quantidade decimal(10,2) not null check(quantidade > 0),
	valor_pago decimal(10,2) not null check(valor_pago > 0),
	data_transacao timestamp default current_timestamp
);



insert into investidores (nome, cpf, nivel_experiencia) values
('joao', '12345678901', 2),
('nathan', '23456789012', 3),
('gabriel', '33456789012', 1),
('othelo', '43456789012', 0),
('miguel', '53456789012', 5);

insert into carteiras (investidor_id, endereco_wallet, rede_blockchain, saldo_usd, status) values
(26, 'dwfuiaMKWIDJU01', 'Bitcoin', 1000.00, 'Ativa'),
(27, 'tgikmrogJIQWIO8', 'Ethereum', 200.50, 'Em Analise'),
(28, 'plhtrfadIWJMNA0', 'Solana', 100000.22, 'Bloqueada'),
(29, 'tiruyjnmIWJQPO7', 'Bitcoin', 555.55, 'Em Analise'),
(30, 'zxcvbnmDFGHJKL2', 'Bitcoin', 12345.69, 'Ativa');

insert into corretoras (nome_exchange, cnpj, email_suporte) values
('Santander', '09876543210987', 'sant@email.com'),
('Banco do Brasil', '98765432109876', 'bancbras@email.com'),
('Caixa', '18765432109876', 'caixa@email.com'),
('Nubank', '76543210987654', 'nuba@email.com'),
('Mercado Pago', '46543210987654', 'mercpago@email.com');

insert into criptomoedas (corretora_id, nome_moeda, preco_unitario_usd, categoria) values
(1, 'Bitcoin', 10000000.00, 'Layer1'),
(2, 'Ethereum', 10000.00, 'DeFi'),
(3, 'Solana', 10.00, 'Stablecoin'),
(4, 'Beastcoin', 1.50, 'Memecoin'),
(5, 'Dogecoin', 69676967.69, 'Memecoin');

insert into transacoes_cripto (carteira_id, criptomoeda_id, quantidade, valor_pago) values
(142, 1, 1.00, 34567890.00),
(143, 2, 5.00, 13000.00),
(144, 3, 1000.00, 10.00),
(145, 4, 10000000.50, 15000000.00),
(146, 5, 0.69, 1.00);



select
	cart.endereco_wallet,
	cart.rede_blockchain,
	cart.saldo_usd,
	i.nome,
	i.cpf,
	cart.status
from
	carteiras cart
join
	investidores i on i.id = cart.investidor_id
where
	cart.status in('Ativa', 'Em Analise')


select
	sum(tc.valor_pago) as soma_total,
	cort.nome_exchange,
	crip.preco_unitario_usd
from
	transacoes_cripto tc
join
	criptomoedas crip on crip.id = tc.criptomoeda_id
join
	corretoras cort on cort.id = crip.corretora_id
group by
	cort.nome_exchange, crip.preco_unitario_usd


select
	cart.endereco_wallet,
	crip.nome_moeda,
	tc.quantidade,
	tc.valor_pago,
	tc.data_transacao
from
	transacoes_cripto tc
join
	carteiras cart on cart.id = tc.carteira_id
join
	criptomoedas crip on crip.id = tc.criptomoeda_id
where
	tc.valor_pago > 500.00
order by
	tc.valor_pago desc;


create view vw_painel_carteiras as
select
	cart.endereco_wallet,
	cart.rede_blockchain,
	cart.status,
	cart.saldo_usd,
	i.nome,
	i.cpf
from
	carteiras cart
join
	investidores i on i.id = cart.investidor_id


create view vw_investimento_total_carteiras as
select
	cart.id,
	cart.endereco_wallet,
	cart.saldo_usd,
	tc.quantidade,
	tc.valor_pago
from
	transacoes_cripto tc
join
	carteiras cart on cart.id = tc.carteira_id
group by
	cart.id, tc.quantidade, tc.valor_pago
